# frozen_string_literal: true

module YouTubeTrendingMap
  module Services
    # Transaction to get hot videos list from YouTube API
    class GetContinentTopVideosList
      include Dry::Transaction

      step :validate_input
      step :get_from_api

      private

      def validate_input(input)
        continent_name = input[:continent_name]
        category_id = input[:category_id]

        Success(continent_name: continent_name, category_id: category_id)
      end

      def get_from_api(input)
        continent_top_videos_list =
          YouTubeTrendingMap::Mapper::ContinentTopVideosList
          .new(App.config.GOOGLE_CLOUD_KEY)
          .get(input[:continent_name], input[:category_id], 10)

        Success(continent_top_videos_list)
      rescue StandardError => error
        Failure(error.to_s)
      end
    end
  end
end
