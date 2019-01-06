# frozen_string_literal: true

module YouTubeTrendingMap
  module Services
    # Transaction to store favorite videos to database
    class AddFavoriteVideosByList
      include Dry::Transaction

      step :validate_input
      step :request_api

      private

      def validate_input(input)
        if !inputs_are_nil(input)
          Success(input)
        else
          puts 'Failure: nil'
          Failure('Some inputs are nil!')
        end
      end

      def request_api(input)
        result =
          Gateway::Api
          .new(YouTubeTrendingMap::App.config)
          .add_favorite_videos_by_list(
            input[:videos].map { |_key, value| value }
          )

        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError => e
        puts e.inspect
        puts e.backtrace
        Failure('Cannot add videos right now; please try again later')
      end

      def inputs_are_nil(input)
        input[:videos].each do |_key, video|
          return true if input_is_nil(video)
        end

        false
      end

      def input_is_nil(input)
        input['origin_id'].nil? || input['title'].nil? ||
          input['channel_title'].nil? || input['view_count'].nil? ||
          input['embed_link'].nil?
      end
    end
  end
end
