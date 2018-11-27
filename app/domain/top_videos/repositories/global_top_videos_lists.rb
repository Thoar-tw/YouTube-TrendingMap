# frozen_string_literal: true

module YouTubeTrendingMap
  module TopVideosRepository
    # Repository for Countries
    class GlobalTopVideosLists
      def self.all
        Database::GlobalTopVideosListsOrm.all.map do |db_record|
          rebuild_entity(db_record)
        end
      end

      def self.find(entity)
        db_record = Database::GlobalTopVideosListsOrm.first(id: entity.id)
        rebuild_entity(db_record)
      end

      def self.find_or_create(entity)
        find(entity) || create(entity)
      end

      def self.create(entity)
        raise 'Global Top videos list already exists' if find(entity)

        db_list = GlobalTopVideosListCreateHelper.new(entity).call
        rebuild_entity(db_list)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::ContinentTopVideosList.new(
          db_record.to_hash.merge(
            videos: TopVideos.rebuild_many(db_record.videos)
          )
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_record|
          GlobalTopVideosLists.rebuild_entity(db_record)
        end
      end

      private_class_method :rebuild_entity, :rebuild_many

      # Helper class to create global top videos list entity,
      # also check the videos on it from the databases
      class GlobalTopVideosListCreateHelper
        def initialize(entity)
          @entity = entity
        end

        def create_entity
          Database::GlobalTopVideosListOrm.create(@entity.to_attr_hash)
        end

        def call
          create_entity.tap do |db_list|
            @entity.videos.each do |video|
              db_list.add_video(TopVideos.find_or_create(video))
            end
          end
        end
      end
    end
  end
end
