# frozen_string_literal: false

require 'net/http'
require 'http'
require 'json'

require_relative 'popular_list.rb'

module APILibrary
  # class to get Youtube data
  class YoutubeAPI
    module Errors
      class NotFound < StandardError; end
      class Unauthorized < StandardError; end
    end

    HTTP_ERROR = {
      401 => Errors::Unauthorized,
      404 => Errors::NotFound
    }.freeze

    def initialize(key, cache: {})
      @api_key = key
      @cache = cache
    end

    def popular_list(region_code)
      response = get_most_popular_videos_list(region_code)
      list_data = JSON.parse(response)
      PopularList.new(list_data)
    end

    private

    # attach params to url path
    def youtube_api_path(params_array)
      path = 'https://www.googleapis.com/youtube/v3/videos?'
      params_array.each.with_index do |param, index|
        path += '&' unless index.zero?
        path += param
      end
      path
    end

    # Use http get to get data from Youtube
    def call_yt_url(url)
      HTTP.get(url)
    end

    # input region code of the country and output trending data with json format
    def get_most_popular_videos_list(region_code)
      param_part = 'part=snippet,player,statistics'
      param_chart = 'chart=mostPopular'
      param_region_code = 'regionCode=' + region_code
      param_video_category_id = 'video_category_id=\'\''
      param_key = 'key=' + GOOGLE_CLOUD_KEY

      param_array = [param_part, param_chart, param_region_code, param_video_category_id, param_key]
      response = call_yt_url(youtube_api_path(param_array))
      response
    end
  end
end

response = File.read('../spec/fixtures/youtube_response.json')
list_data = JSON.parse(response)
PopularList.new(list_data)