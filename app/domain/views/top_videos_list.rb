# frozen_string_literal: true

require_relative 'video'

module YouTubeTrendingMap
  module Views
    # View for a Youtube top video list entity
    class TopVideosList
      def initialize(list)
        @list = list
        @videos = list.videos.map.with_index { |video, i| Video.new(video, i) }
      end

      def each
        @videos.each do |video|
          yield video
        end
      end

      def any?
        @videos.any?
      end
    end
  end
end
