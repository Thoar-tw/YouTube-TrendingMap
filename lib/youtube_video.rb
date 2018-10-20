# frozen_string_literal: false

module APILibrary
  # Data structure of an Youtube video
  class YoutubeVideo
    def initialize(video_data)
      @video_data = video_data
    end

    def id
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
      @video_data['statistics']['viewCount']
    end

    def like_count
      @video_data['statistics']['likeCount']
    end

    def dislike_count
      @video_data['statistics']['dislikeCount']
    end

    def embed_link
      array = @video_data['player']['embedHtml'].split(' ')
      array.each do |attr|
        return 'https:' + attr.split(/"/)[1] if attr.start_with?('src=')
      end
    end
  end
end
