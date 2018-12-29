# frozen_string_literal: true

module YouTubeTrendingMap
  module Views
    # View for a single Youtube top video entity 
    class FavoriteVideo
      def initialize(video, index = nil)
        @video = video
        @index = index
      end

      def index_str
        "video[#{@index}]"
      end

      def index
        @index
      end

      def entity
        @video
      end

      def origin_id
        @video.origin_id
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
