# frozen_string_literal: true

require_relative 'youtube_video_mapper.rb'
require_relative 'country_mapper.rb'

module YouTubeTrendingMap
  module Mapper
    # Data structure of trending list queried from Youtube
    class TrendingList
      def initialize(api_key, gateway_class = YouTubeTrendingMap::YoutubeAPI)
        # @api_key = api_key
        # @gateway_class = gateway_class
        @gateway = gateway_class.new(api_key)
      end

      def get(region_code, category_id, max_results)
        data = @gateway.trending_list_data(region_code, category_id, max_results)
        build_entity(data)
      end

      def build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from raw response data structure
      class DataMapper
        def initialize(list_data)
          @list_data = list_data
          @yt_video_mapper = Mapper::YoutubeVideo.new
          @country_mapper = Mapper::Country.new
        end

        def build_entity
          YouTubeTrendingMap::Entity::TrendingList.new(
            id: nil,
            count: count,
            belonging_country: belonging_country,
            videos: videos
          )
        end

        private

        def count
          @list_data['items'].length
        end

        def belonging_country
          @country_mapper.build_entity_from_region_code(@list_data['region_code'])
        end

        # Return an array of YoutubeVideo objects
        def videos
          @yt_video_mapper.build_video_items(@list_data['items'])
          # @videos = []
          # @list_data['items'].each do |item|
          #   @videos << YoutubeVideo.new(item)
          # end
          # @videos
        end
      end
    end
  end
end
