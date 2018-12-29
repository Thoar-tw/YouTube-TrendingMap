# frozen_string_literal: true

module YouTubeTrendingMap
  module Services
    # Transaction to store favorite videos to database
    class DeleteFavoriteVideo
      include Dry::Transaction

      step :delete_video

      private

      def delete_video(input)
        puts 'inside delete_video'
        puts input[:origin_id]
        result =
          FavoriteVideosRepository::FavoriteVideos
          .delete_video(input[:origin_id])

        Success(result)
      rescue StandardError => error
        puts error.backtrace.join("\n")
        puts 'Having trouble accessing the database'
        Failure('Having trouble accessing the database')
      end
    end
  end
end
