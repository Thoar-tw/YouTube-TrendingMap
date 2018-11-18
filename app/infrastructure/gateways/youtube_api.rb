# frozen_string_literal: true

require 'http'
require 'json'

module YouTubeTrendingMap
  # class to get Youtube data
  class YoutubeAPI
    module Errors
      class BadRequest < StandardError; end
      class NotFound < StandardError; end
      class Unauthorized < StandardError; end
    end

    HTTP_ERROR = {
      400 => Errors::BadRequest,
      401 => Errors::Unauthorized,
      404 => Errors::NotFound
    }.freeze

    def initialize(api_key, cache: {})
      @api_key = api_key
      @cache = cache
    end

    def hot_videos_data(region_code, category_id, max_results_count)
      response = get_most_popular_videos(region_code, category_id, max_results_count)
      data = JSON.parse(response)
      data['region_code'] = region_code
      data
    end

    def top_videos_data(region_code, category_id, max_results_count)
      response = get_videos_ordered_by_view_count(region_code, category_id, max_results_count)
      data = JSON.parse(response)
      data['region_code'] = region_code
      data
    end

    def certain_id_videos_data(video_ids)
      response = get_videos_data_by_id(video_ids)
      data = JSON.parse(response)
      data
    end

    private

    # Attach params to url path
    def youtube_api_path(params_array, type)
      path = 'https://www.googleapis.com/youtube/v3/' + type + '?'
      params_array.each.with_index do |param, index|
        path += '&' unless index.zero?
        path += param
      end
      path
    end

    # Use http get to get data from Youtube
    def call_yt_url(url)
      result = HTTP.get(url)
      successful?(result) ? result : raise_error(result)
    end

    # Input region code of the country and get trending videos with json format
    def get_most_popular_videos(region_code, category_id, max_results_count)
      param_part = 'part=snippet,player,statistics'
      param_chart = 'chart=mostPopular'
      param_region_code = 'regionCode=' + region_code
      param_video_category_id = 'videoCategoryId=' + category_id.to_s
      param_max_results = 'maxResults=' + max_results_count.to_s
      param_key = 'key=' + @api_key

      param_array = [param_part, param_chart, param_region_code, param_video_category_id, param_max_results, param_key]
      response = call_yt_url(youtube_api_path(param_array, 'videos'))
      response
    end

    def get_videos_ordered_by_view_count(region_code, category_id, max_results_count)
      param_part = 'part=snippet'
      param_region_code = 'regionCode=' + region_code
      param_video_category_id = 'videoCategoryId=' + category_id.to_s
      param_max_results = 'maxResults=' + max_results_count.to_s
      param_order = 'order=viewCount'
      param_key = 'key=' + @api_key

      param_array = [param_part, param_region_code, param_video_category_id, param_max_results, param_order, param_key]
      response = call_yt_url(youtube_api_path(param_array, 'search'))
      response
    end

    def get_videos_data_by_id(video_ids)
      param_part = 'part=snippet,player,statistics'
      param_id = 'id='
      video_ids.each.with_index do |video_id, index|
        param_id += index == (video_ids.size - 1) ? video_id + ', ' : video_id
      param_key = 'key=' + @api_key

      param_array = [param_part, param_id, param_key]
      response = call_yt_url(youtube_api_path(param_array, 'videos'))
      response
    end

    def successful?(result)
      # HTTP_ERROR.key(result.code) ? false : true
      HTTP_ERROR.keys.include?(result.code) ? false : true # rubocop:disable Performance/InefficientHashSearch
    end

    def raise_error(result)
      raise(HTTP_ERROR[result.code])
    end
  end
end
