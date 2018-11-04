# frozen_string_literal: false

module YouTubeTrendingMap
  # Data structure of an Youtube video
  class YoutubeVideoMapper
    def initialize; end

    def build_video_items(items_data)
      items_data.map do |item|
        build_entity(item)
      end
    end

    def build_entity(data)
      DataMapper.new(data).build_entity
    end

    # Extracts entity specific elements from raw response data structure
    class DataMapper
      def initialize(video_data)
        @video_data = video_data
      end

      def build_entity # rubocop:disable Metrics/MethodLength
        YouTubeTrendingMap::Entity::YoutubeVideo.new(
          id: nil,
          origin_id: origin_id,
          publish_time: publish_time,
          title: title,
          description: description,
          channel_title: channel_title,
          view_count: view_count,
          like_count: like_count,
          dislike_count: dislike_count,
          embed_link: embed_link
        )
      end

      private

      def origin_id
        @video_data['id']
      end

      def publish_time
        @video_data['snippet']['publishedAt']
      end

      def title
        @video_data['snippet']['title']
      end

      def description
        @video_data['snippet']['description']
      end

      def channel_title
        @video_data['snippet']['channelTitle']
      end

      def view_count
        @video_data['statistics']['viewCount'].to_i
      end

      def like_count
        @video_data['statistics']['likeCount'].to_i
      end

      def dislike_count
        @video_data['statistics']['dislikeCount'].to_i
      end

      def embed_link
        array = @video_data['player']['embedHtml'].split(' ')
        array.each do |attr|
          return 'https:' + attr.split(/"/)[1] if attr.start_with?('src=')
        end
      end
    end
  end
end
