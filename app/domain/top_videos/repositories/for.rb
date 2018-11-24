# frozen_string_literal: true

require_relative 'global_top_videos_lists'
require_relative 'continent_top_videos_lists'
require_relative 'country_top_videos_lists'
require_relative 'top_videos'
require_relative 'countries'

module YouTubeTrendingMap
  module TopVideosRepository
    # Finds the right repository for an entity object or class
    class For
      ENTITY_REPOSITORY = {
        Entity::GlobalTopVideosList => GlobalTopVideosLists,
        Entity::ContinentTopVideosList => ContinentTopVideosLists,
        Entity::CountryTopVideosList => CountryTopVideosLists,
        Entity::TopVideo => TopVideos,
        Entity::Country => Countries
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
