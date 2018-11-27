# frozen_string_literal: true

module YouTubeTrendingMap
  module TopVideosRepository
    # Repository for Countries
    class CountryTopVideosLists
      def self.all
        Database::CountryTopVideosListOrm.all.map do |db_record|
          rebuild_entity(db_record)
        end
      end

      def self.find(entity)
        db_record = Database::CountryTopVideosListOrm.first(id: entity.id)
        rebuild_entity(db_record)
      end

      def self.find_all_by_country(country_name)
        # SELECT * FROM `country_top_videos_lists`
        # WHERE (`belonging_country` = `country_name`)
        db_lists =  Database::CountryTopVideosListOrm
                    .where(belonging_country: country_name)
        rebuild_many(db_lists)
      end

      def self.find_by_country(country_name)
        # SELECT * FROM `country_top_videos_lists`
        # WHERE (`belonging_country` = `country_name`)
        db_list = Database::CountryTopVideosListOrm
                  .where(belonging_country: country_name)
                  .first

        rebuild_entity(db_list)
      end

      def self.find_or_create(entity)
        find(entity) || create(entity)
      end

      def self.create(entity)
        raise 'Country top videos list already exists' if find(entity)

        db_list = CountryTopVideosListCreateHelper.new(entity).call
        rebuild_entity(db_list)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::CountryTopVideosList.new(
          db_record.to_hash.merge(
            belonging_country: Countries.rebuild_entity(db_record.belonging_country),
            videos: TopVideos.rebuild_many(db_record.videos)
          )
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_record|
          HotVideosLists.rebuild_entity(db_record)
        end
      end

      private_class_method :rebuild_entity, :rebuild_many

      # Helper class to create trending_list entity,
      # also check its belonging country & videos on it from the databases
      class CountryTopVideosListCreateHelper
        def initialize(entity)
          @entity = entity
        end

        def create_entity
          Database::CountryTopVideosListOrm.create(@entity.to_attr_hash)
        end

        def call
          belonging_country = Countries.find_or_create(@entity.belonging_country)

          create_entity.tap do |db_list|
            db_list.update(belonging_country: belonging_country)

            @entity.videos.each do |video|
              db_list.add_video(TopVideos.find_or_create(video))
            end
          end
        end
      end
    end
  end
end
