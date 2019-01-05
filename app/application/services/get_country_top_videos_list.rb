# frozen_string_literal: true

module YouTubeTrendingMap
  module Services
    # Transaction to get hot videos list from YouTube API
    class GetCountryTopVideosList
      include Dry::Transaction

      step :validate_input
      step :request_api
      step :reify_videos_list

      private

      def validate_input(input)
        if input.key?(:region_code) && input.key?(:category_id)
          region_code = input[:region_code]
          category_id = input[:category_id]

          Success(region_code: region_code, category_id: category_id)
        else
          Failure(input.errors.values.join('; '))
        end
      end

      def request_api(input) # rubocop:disable Metrics/AbcSize
        result =
          Gateway::Api
          .new(YouTubeTrendingMap::App.config)
          .get_country_top_videos(input[:region_code], input[:category_id])

        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError => e
        puts e.inspect
        puts e.backtrace
        Failure('Cannot get country top videos list, please try again later!')
      end

      def reify_videos_list(videos_list_json)
        Representer::CountryTopVideosList
          .new(OpenStruct.new)
          .from_json(videos_list_json)
          .yield_self { |videos| Success(videos) }
      rescue StandardError
        Failure('Error in the country top videos list, please try again!')
      end
    end
  end
end
