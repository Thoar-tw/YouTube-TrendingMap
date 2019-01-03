# frozen_string_literal: true

require_relative 'video'

module YouTubeTrendingMap
  module Views
    # View for a Youtube hot video list entity
    class HotVideosList
      def initialize(list)
        @list = list
        @videos = list.videos.map.with_index { |video, i| Video.new(video, i) }
      end

      def each
        @videos.each do |video|
          yield video
        end
      end

      def belonging_country
        @list.belonging_country
      end
    end
  end
end
