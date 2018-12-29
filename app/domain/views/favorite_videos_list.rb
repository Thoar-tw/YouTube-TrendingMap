# frozen_string_literal: true

require_relative 'video'

module YouTubeTrendingMap
  module Views
    # View for a Youtube hot video list entity
    class FavoriteVideosList
      def initialize(array)
        @videos = array.each.map.with_index do |video, i|
          FavoriteVideo.new(video, i)
        end
      end

      def each
        @videos.each do |video|
          yield video
        end
      end
    end
  end
end
