# frozen_string_literal: true

require_relative 'top_video_mapper.rb'

module YouTubeTrendingMap
  module Mapper
    # Data structure of trending list queried from Youtube
    class CountryTopVideos
      def initialize(api_key, gateway_class = YouTubeTrendingMap::YoutubeAPI)
        @gateway = gateway_class.new(api_key)
      end

      def get(region_code, category_id, max_results)
        data = @gateway.top_videos_data(region_code, category_id, max_results)
        build_entity(data)
      end

      def build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from raw response data structure
      class DataMapper
        def initialize(list_data)
          @list_data = list_data
          @top_video_mapper = Mapper::TopVideo.new
          @country_mapper = Mapper::Country.new
        end

        def build_entity
          YouTubeTrendingMap::Entity::CountryRanking.new(
            id: nil,
            count: count,
            belonging_country: belonging_country,
            top_videos: top_videos
          )
        end

        private

        def count
          @list_data['items'].length
        end

        def belonging_country
          @country_mapper.build_entity_from_region_code(@list_data['region_code'])
        end

        # Return an array of TopVideo entities
        def top_videos
          video_ids = []
          @list_data['items'].each do |top_video|
            video_ids.push(top_video['id']['videoId'])
          end

          # since we need to call youtube/api/videos to get the embed_link
          videos_data = @gateway.certain_id_videos_data(video_ids)
          @top_video_mapper.build_video_items(videos_data)
        end
      end
    end
  end
end
