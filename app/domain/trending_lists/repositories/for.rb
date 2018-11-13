# frozen_string_literal: true

require_relative 'countries'
require_relative 'trending_lists'
require_relative 'youtube_videos'

module YouTubeTrendingMap
  module Repository
    # Finds the right repository for an entity object or class
    class For
      ENTITY_REPOSITORY = {
        Entity::Country => Countries,
        Entity::TrendingList => TrendingLists,
        Entity::YoutubeVideo => YoutubeVideos
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
