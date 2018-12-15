# frozen_string_literal: true

module YouTubeTrendingMap
  module Services
    # Transaction to get hot videos list from YouTube API
    class GetGlobalTopVideosList
      include Dry::Transaction

      step :validate_input
      step :get_from_api

      private

      def validate_input(input)
        category_id = input[:category_id]
        Success(category_id: category_id)
      end

      def get_from_api(input)
        global_top_videos_list =
          YouTubeTrendingMap::Mapper::GlobalTopVideosList
          .new(App.config.GOOGLE_CLOUD_KEY)
          .get(input[:category_id], 10)

        Success(global_top_videos_list)
      rescue StandardError => error
        Failure(error.to_s)
      end
    end
  end
end
