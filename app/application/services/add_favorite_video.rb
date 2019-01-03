# frozen_string_literal: true

module YouTubeTrendingMap
  module Services
    # Transaction to store favorite videos to database
    class AddFavoriteVideo
      include Dry::Transaction

      step :validate_input
      step :request_api

      private

      def validate_input(input)
        if !input_is_nil(input)
          Success(input)
        else
          puts 'Failure: nil'
          Failure(input.errors.values.join('; '))
        end
      end

      def request_api(input)
        result =
          Gateway::Api
          .new(YouTubeTrendingMap::App.config)
          .add_favorite_video(input)

        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError => e
        puts e.inspect
        puts e.backtrace
        Failure('Cannot add projects right now; please try again later')
      end

      def input_is_nil(input)
        input[:origin_id].nil? || input[:title].nil? ||
          input[:channel_title].nil? || input[:view_count].nil? ||
          input[:embed_link].nil?
      end
    end
  end
end
