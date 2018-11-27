# frozen_string_literal: true

module YouTubeTrendingMap
  module Mapper
    # Data structure of trending list queried from Youtube
    class GlobalTopVideosList
      include Mixins::TopVideosAggregator

      def initialize(api_key, gateway_class = YouTubeTrendingMap::YoutubeAPI)
        @api_key = api_key
        @gateway_class = gateway_class
      end

      def get(category_id, max_results)
        videos_lists = get_lists_from_continents(category_id, max_results)
        build_entity(aggregate(videos_lists))
      end

      def build_entity(data)
        YouTubeTrendingMap::Entity::GlobalTopVideosList.new(
          id: nil,
          count: data.length,
          videos: data
        )
      end

      private

      def get_lists_from_continents(category_id, max_results)
        continents = ['asia']
        # continents = CONTINENT_COUNTRY_CODES.keys
        list = []
        continents.each do |continent|
          list << Mapper::ContinentTopVideosList
                  .new(continent, @api_key, @gateway_class)
                  .get(category_id, max_results)
        end

        puts "get_lists_from_continents"
        puts list

        list
      end
    end
  end
end
