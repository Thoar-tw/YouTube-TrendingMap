# frozen_string_literal: false

require_relative 'spec_helper.rb'
require_relative 'helpers/vcr_helper.rb'

describe 'Tests OSM API library' do
  before do
    VcrHelper.configure_vcr_for_osm
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'OSM country data' do
    it 'HAPPY: should provide correct country attributes' do
      country = YouTubeTrendingMap::CountryMapper.new.query(COUNTRY_NAME)
      _(country.place_id).must_equal CORRECT_OSM['place_id'].to_i
      _(country.name).must_equal CORRECT_OSM['name']
      _(country.longitude).must_equal CORRECT_OSM['lon'].to_f
      _(country.latitude).must_equal CORRECT_OSM['lat'].to_f
    end

    it 'BAD: should raise exception while the query country name is invalid' do
      proc do
        YouTubeTrendingMap::CountryMapper.new.query('mars')
      end.must_raise YouTubeTrendingMap::OSMDataAPI::Errors::EmptyResponse
    end
  end
end

describe 'Tests Youtube API library' do
  before do
    VcrHelper.configure_vcr_for_youtube
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Youtube popular video list' do
    it 'HAPPY: should provide a list of videos, and each video has non nil Video attributes' do
      list = YouTubeTrendingMap::PopularListMapper.new(GOOGLE_CLOUD_KEY).query(COUNTRY_CODE, DEFAULT_CATEGORY)
      list.videos.each do |video|
        _(video.origin_id).wont_be_nil
        _(video.publish_time).wont_be_nil
        _(video.title).wont_be_nil
        _(video.description).wont_be_nil
        _(video.channel_title).wont_be_nil
        _(video.view_count).wont_be_nil
        _(video.like_count).wont_be_nil
        _(video.dislike_count).wont_be_nil
        _(video.embed_link).wont_be_nil
      end
    end

    it 'HAPPY: should provide a list of videos, and each video has a publish_time attribute in the correct timestamp format' do
      time_regex = /(\d\d\d\d)-(\d\d)-(\d\d)T(\d\d):(\d\d):(\d\d).000Z/
      list = YouTubeTrendingMap::PopularListMapper.new(GOOGLE_CLOUD_KEY).query(COUNTRY_CODE, DEFAULT_CATEGORY)
      list.videos.each do |video|
        _(video.publish_time).must_match(time_regex)
      end
    end

    it 'HAPPY: should provide a list of videos, and each video has a embed_link attribute in the correct url prefix' do
      link_regex = %r{https\:\/\/www\.youtube\.com\/embed\/(.*?)}
      list = YouTubeTrendingMap::PopularListMapper.new(GOOGLE_CLOUD_KEY).query(COUNTRY_CODE, DEFAULT_CATEGORY)
      list.videos.each do |video|
        _(video.embed_link).must_match(link_regex)
      end
    end

    it 'BAD: should raise exception while the key is invalid' do
      proc do
        YouTubeTrendingMap::PopularListMapper.new('INVALID_KEY').query(COUNTRY_CODE, DEFAULT_CATEGORY)
      end.must_raise YouTubeTrendingMap::YoutubeAPI::Errors::BadRequest
    end
  end
end
