# frozen_string_literal: true

require 'dry/monads'

module YouTubeTrendingMap
  module Services
    # Retrieves array of all listed project entities
    class ListFavoriteVideos
      include Dry::Monads::Result::Mixin

      def call
        favorite_videos =
          FavoriteVideosRepository::For.klass(Entity::FavoriteVideo).all

        Success(favorite_videos)
      rescue StandardError
        Failure('Could not access database')
      end
    end
  end
end
