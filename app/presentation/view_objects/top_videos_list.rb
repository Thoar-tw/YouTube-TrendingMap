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

      def belonging_location
        case @list.type
        when 'global'
          'Global'
        when 'continent'
          @list.belonging_continent
        when 'country'
          @list.belonging_country
        end
      end

      def any?
        @videos.any?
      end
    end
  end
end
