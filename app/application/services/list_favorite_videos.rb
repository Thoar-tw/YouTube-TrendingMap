# frozen_string_literal: true

require 'dry/monads'

module YouTubeTrendingMap
  module Services
    # Retrieves array of all listed project entities
    class ListFavoriteVideos
      include Dry::Transaction

      step :request_api
      step :reify_list

      private

      def request_api
        Gateway::Api
          .new(YouTubeTrendingMap::App.config)
          .list_favorite_videos
          .yield_self do |result|
            result.success? ? Success(result.payload) : Failure(result.message)
          end
      rescue StandardError => e
        puts e.inspect
        puts e.backtrace
        Failure('Could not access our API')
      end

      def reify_list(videos_json)
        Representer::FavoriteVideosList
          .new(OpenStruct.new)
          .from_json(videos_json)
          .yield_self { |videos| Success(videos) }
      rescue StandardError => e
        puts e.inspect
        puts e.backtrace
        Failure('Could not parse response from API')
      end
    end
  end
end
