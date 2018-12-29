# frozen_string_literal: true

module YouTubeTrendingMap
  module Services
    # Transaction to get hot videos list from YouTube API
    class GetHotVideosList
      include Dry::Transaction

      step :validate_input
      step :get_from_api
      step :reify_videos_list

      private

      def validate_input(input)
        region_code = input[:region_code]
        category_id = input[:category_id]

        Success(region_code: region_code, category_id: category_id)
      end

      def get_from_api(input) # rubocop:disable Metrics/AbcSize
        result =
          Gateway::Api
          .new(YouTubeTrendingMap::App.config)
          .get_hot_videos(
            input[:region_code], input[:category_id], 10
          )

        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError
        puts e.inspect + '\n' + e.backtrace
        Failure('Cannot get hot videos list, please try again later!')
      end

      def reify_videos_list(videos_list_json)
        Representer::HotVideosList
          .new(OpenStruct.new)
          .from_json(videos_list_json)
          .yield_self { |videos| Success(videos) }
      rescue StandardError
        Failure('Error in the hot videos list, please try again!')
      end
    end
  end
end
