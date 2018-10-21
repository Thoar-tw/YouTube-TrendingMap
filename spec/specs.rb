# frozen_string_literal: false

require 'minitest/autorun'
require 'minitest/spec'
require 'spec_helper.rb'
# require_relative  'osm_data_api'
require_relative '../lib/youtube_api'
# require 'yaml'
describe 'Api library' do
  include APILibrary
  USERNAME = 'thoar'.freeze
  PROJECT_NAME = 'YoutubeTrendingMap'.freeze

  # CONFIG = YAML.safe_load(File.read('config/secretes.yml'))
  # GOOGLE_API_TOKEN = CONFIG['token']

  # @osplace = OSMDataAPI.new
  YOUTUBE_service = APILibrary::YoutubeAPI
  SAMPLE_QUERY = 'part=snippet&chart=mostPopular&region_code=US'

  describe 'Project information' do
    it 'if url contains keys ' do
      #YOUTUBE_DATA.youtube_api_path(SAMPLE_QUERY).must_include GOOGLE_API_TOKEN
      YOUTUBE_service.youtube_api_path(SAMPLE_QUERY).must_include 'AIzaSyAD656N9isRF8t11FeFUvizKJCTB07Vrqo'
    end
    it " apis exists" do 
     ytService =  APILibrary::YoutubeAPI.new
     expect(ytService).must_be_same_as(APILibrary::YoutubeAPI)
    end 
    it 'test cassette':vcr do
    
        ytService =  APILibrary::YoutubeAPI.new

    
    end
  end
end
