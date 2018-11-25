# frozen_string_literal: true

module YouTubeTrendingMap
  module Views
    # View for a single Youtube top video entity 
    class Video
      def initialize(video, index = nil)
        @video = video
        @index = index
      end

      def index_str
        "project[#{@index}]"
      end

      def entity
        @video
      end

      def title
        @video.title
      end

      def channel_title
        @video.channel_title
      end

      def view_count
        @video.view_count
      end

      def embed_link
        @video.embed_link
      end
    end
  end
end
