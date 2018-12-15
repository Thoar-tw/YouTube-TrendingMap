# frozen_string_literal: true

module YouTubeTrendingMap
  module Services
    # Transaction to get hot videos list from YouTube API
    class GetCountryTopVideosList
      include Dry::Transaction

      step :validate_input
      step :get_from_api

      private

      def validate_input(input)
        region_code = input[:region_code]
        category_id = input[:category_id]

        Success(region_code: region_code, category_id: category_id)
      end

      def get_from_api(input)
        country_top_videos_list =
          YouTubeTrendingMap::Mapper::CountryTopVideosList
          .new(App.config.GOOGLE_CLOUD_KEY)
          .get(input[:region_code], input[:category_id], 10)

        Success(country_top_videos_list)
      rescue StandardError => error
        Failure(error.to_s)
      end
    end
  end
end
