# frozen_string_literal: true

require_relative 'favorite_videos'

module YouTubeTrendingMap
  module FavoriteVideosRepository
    # Finds the right repository for an entity object or class
    class For
      ENTITY_REPOSITORY = {
        Entity::FavoriteVideo => FavoriteVideos
      }.freeze

      def self.klass(entity_klass)
        ENTITY_REPOSITORY[entity_klass]
      end

      def self.entity(entity_object)
        ENTITY_REPOSITORY[entity_object.class]
      end
    end
  end
end
