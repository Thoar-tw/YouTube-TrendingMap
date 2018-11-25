# frozen_string_literal: true

module YouTubeTrendingMap
  module Mapper
    # Data structure of trending list queried from Youtube
    class GlobalTopVideosList
      include Mixins::TopVideosAggregator

      def initialize(api_key, gateway_class = YouTubeTrendingMap::YoutubeAPI)
      end

      def build_entity(data)
        DataMapper.new(data).build_entity
      end
    end
  end
end
