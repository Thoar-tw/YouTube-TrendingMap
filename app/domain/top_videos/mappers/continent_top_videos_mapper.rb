# frozen_string_literal: true

module YouTubeTrendingMap
  module Mapper
    # Data structure of trending list queried from Youtube
    class ContinentTopVideos
      include Mixins::TopVideosAggregator

      attr_reader :country_top_videos

      def initialize(country_top_videos:)
        @country_top_videos = country_top_videos
      end


    end
  end
end
