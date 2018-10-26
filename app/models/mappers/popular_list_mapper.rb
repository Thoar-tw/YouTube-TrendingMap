# frozen_string_literal: false

require_relative 'youtube_video_mapper.rb'

module APILibrary
  # Data structure of popular list queried from Youtube
  class PopularListMapper
    def initialize(api_key, gateway_class = APILibrary::YoutubeAPI)
      # @api_key = api_key
      # @gateway_class = gateway_class
      @gateway = gateway_class.new(api_key)
    end

    def query(region_code, category_id)
      data = @gateway.popular_list_data(region_code, category_id)
      build_entity(data)
    end

    def build_entity(data)
      DataMapper.new(data).build_entity
    end

    # Extracts entity specific elements from raw response data structure
    class DataMapper
      def initialize(list_data)
        @list_data = list_data
        @yt_video_mapper = YoutubeVideoMapper.new
      end

      def build_entity
        APILibrary::Entity::PopularList.new(
          count: count,
          videos: videos
        )
      end

      private

      def count
        @list_data['items'].length
      end

      # Return an array of YoutubeVideo objects
      def videos
        @yt_video_mapper.build_video_items(@list_data['items'])
        # @videos = []
        # @list_data['items'].each do |item|
        #   @videos << YoutubeVideo.new(item)
        # end
        # @videos
      end
    end
  end
end
