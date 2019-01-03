# frozen_string_literal: true

module YouTubeTrendingMap
  module Services
    # Transaction to store favorite videos to database
    class DeleteFavoriteVideo
      include Dry::Transaction

      step :request_api

      private

      def request_api(input)
        result =
          Gateway::Api
          .new(YouTubeTrendingMap::App.config)
          .delete_favorite_video(input)

        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError => e
        puts e.inspect
        puts e.backtrace
        Failure('Cannot delete projects right now; please try again later')
      end
    end
  end
end
