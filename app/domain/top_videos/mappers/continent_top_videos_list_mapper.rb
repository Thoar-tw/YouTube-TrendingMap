# frozen_string_literal: true

module YouTubeTrendingMap
  module Mapper
    # Data structure of trending list queried from Youtube
    class ContinentTopVideosList
      include Mixins::TopVideosAggregator

      def initialize(api_key, gateway_class = YouTubeTrendingMap::YoutubeAPI)
        @api_key = api_key
        @gateway_class = gateway_class
      end

      def get(continent, category_id, max_results)
        videos_lists = get_lists_from_countries_in_same_continent(continent)
        # aggregate(videos_lists)
      end

      def build_entity
        Entity::ContinentTopVideosList.new(
          count: count,
          belonging_continent: @continent,
          videos: videos
        )
      end

      private

      def count
        video_list.length
      end

      def videos
      end

      def get_lists_from_countries_in_same_continent(continent)
        country_codes = ['tw', 'jp', 'kr']
        # country_codes = country_codes_in_same_continent(continent)
        country_codes.each do |country_code|
          list = Mapper::CountryTopVideosList.get(country_code, category_id, max_results)
          puts list
        end
      end

      def country_codes_in_same_continent(continent)
        country_codes = []
        CONTINENT_COUNTRY_CODES[continent].each do |country_code, _|
          country_codes << country_code
        end
        country_codes
      end
    end
  end
end
