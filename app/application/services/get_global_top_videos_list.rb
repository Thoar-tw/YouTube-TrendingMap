# frozen_string_literal: true

module YouTubeTrendingMap
  module Services
    # Transaction to get hot videos list from YouTube API
    class GetGlobalTopVideosList
      include Dry::Transaction

      step :validate_input
      step :get_from_api
      step :reify_videos_list

      private

      def validate_input(input)
        category_id = input[:category_id]
        Success(category_id: category_id)
      end

      def get_from_api(input) # rubocop:disable Metrics/AbcSize
        result =
          Gateway::Api
          .new(YouTubeTrendingMap::App.config)
          .get_global_top_videos(input[:category_id], 10)

        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError
        puts e.inspect + '\n' + e.backtrace
        Failure('Cannot get global top videos list, please try again later!')
      end

      def reify_videos_list(videos_list_json)
        Representer::GlobalTopVideosList
          .new(OpenStruct.new)
          .from_json(videos_list_json)
          .yield_self { |videos| Success(videos) }
      rescue StandardError
        Failure('Error in the global top videos list, please try again!')
      end
    end
  end
end
