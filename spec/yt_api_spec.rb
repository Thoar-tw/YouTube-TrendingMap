# frozen_string_literal: false

require 'minitest/spec'
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

  # @osplace = OSMDataAPI.new
  describe 'Youtube popular video list' do
    it 'HAPPY: should provide a list of video of Video class' do
      time_regex = /(\d\d\d\d)-(\d\d)-(\d\d)T(\d\d):(\d\d):(\d\d).000Z/
      link_regex = %r{https\:\/\/www\.youtube\.com\/embed\/(.*?)}
      list = APILibrary::YoutubeAPI.new(GOOGLE_CLOUD_KEY).popular_list(COUNTRY_CODE)
      list.videos.each do |video|
        _(video.id).wont_be_nil
        _(video.publish_time).must_match(time_regex)
        _(video.title).wont_be_nil
        _(video.channel_title).wont_be_nil
        _(video.embed_link).must_match(link_regex)
      end
    end

    # it 'BAD: should raise exception while unauthorized' do
    #   proc do
    #     APILibrary::YoutubeAPI.new('BAD_TOKEN').popular_list(COUNTRY_NAME) 
    #   end.must_raise APILibrary::YoutubeAPI::Response::Unauthorized
    # end

    # it 'test cassette':vcr do
    #   ytService =  APILibrary::YoutubeAPI.new
    # end
  end
end
