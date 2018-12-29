# frozen_string_literal: true

module YouTubeTrendingMap
  module Services
    # Transaction to store favorite videos to database
    class AddFavoriteVideo
      include Dry::Transaction

      step :validate_input
      step :store_video

      private

      def validate_input(input)
        if !(input[:origin_id].nil? || input[:title].nil? || 
          input[:channel_title].nil? || input[:view_count].nil? ||
          input[:embed_link].nil?)
          Success(input)
        else
          puts 'Failure: nil'
          Failure('Some inputs are nil!')
        end
      end

      def store_video(input) # rubocop:disable Metrics/MethodLength
        video = Entity::FavoriteVideo.new(
          origin_id: input[:origin_id],
          title: input[:title],
          channel_title: input[:channel_title],
          view_count: input[:view_count],
          embed_link: input[:embed_link]
        )

        video_stored = FavoriteVideosRepository::For.entity(video).find_or_create(video)

        Success(video_stored)
      rescue StandardError => error
        puts error.backtrace.join("\n")
        Failure('Having trouble accessing the database')
      end
    end
  end
end
