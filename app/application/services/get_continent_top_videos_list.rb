# frozen_string_literal: true

module YouTubeTrendingMap
  module Services
    # Transaction to get hot videos list from YouTube API
    class GetContinentTopVideosList
      include Dry::Transaction

      step :validate_input
      step :request_api
      step :reify_videos_list

      private

      def validate_input(input)
        continent_name = input[:continent_name]
        category_id = input[:category_id]

        Success(continent_name: continent_name, category_id: category_id)
      end

      def request_api(input) # rubocop:disable Metrics/AbcSize
        result =
          Gateway::Api
          .new(YouTubeTrendingMap::App.config)
          .get_continent_top_videos(input[:continent_name], input[:category_id])

        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError => e
        puts e.inspect
        puts e.backtrace
        Failure('Cannot get continent top videos list, please try again later!')
      end

      def reify_videos_list(videos_list_json)
        Representer::ContinentTopVideosList
          .new(OpenStruct.new)
          .from_json(videos_list_json)
          .yield_self { |videos| Success(videos) }
      rescue StandardError
        Failure('Error in the continent top videos list, please try again!')
      end
    end
  end
end
