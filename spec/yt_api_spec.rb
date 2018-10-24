# frozen_string_literal: false

require_relative 'spec_helper.rb'

describe 'Tests Youtube API library' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock
    c.filter_sensitive_data('<GOOGLE CLOUD KEY>') { GOOGLE_CLOUD_KEY }
  end

  before do
    VCR.insert_cassette CASSETTE_FILE_YT, record: :new_episodes, match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'Youtube popular video list' do
    it 'HAPPY: should provide a list of videos, and each video has non nil Video attributes' do
      list = APILibrary::PopularListMapper.new(GOOGLE_CLOUD_KEY).query(COUNTRY_CODE)
      list.videos.each do |video|
        _(video.id).wont_be_nil
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
      list = APILibrary::PopularListMapper.new(GOOGLE_CLOUD_KEY).query(COUNTRY_CODE)
      list.videos.each do |video|
        _(video.publish_time).must_match(time_regex)
      end
    end

    it 'HAPPY: should provide a list of videos, and each video has a embed_link attribute in the correct url prefix' do
      link_regex = %r{https\:\/\/www\.youtube\.com\/embed\/(.*?)}
      list = APILibrary::PopularListMapper.new(GOOGLE_CLOUD_KEY).query(COUNTRY_CODE)
      list.videos.each do |video|
        _(video.embed_link).must_match(link_regex)
      end
    end

    it 'BAD: should raise exception while the key is invalid' do
      proc do
        APILibrary::PopularListMapper.new('INVALID_KEY').query(COUNTRY_CODE)
      end.must_raise APILibrary::YoutubeAPI::Errors::BadRequest
    end
  end
end
