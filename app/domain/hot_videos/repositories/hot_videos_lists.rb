# frozen_string_literal: true

# require_relative 'countries'
# require_relative 'youtube_videos'

module YouTubeTrendingMap
  module Repository
    # Repository for Countries
    class HotVideosLists
      def self.all
        Database::HotVideosListOrm.all.map do |db_record|
          rebuild_entity(db_record)
        end
      end

      def self.find(entity)
        db_record = Database::HotVideosListOrm.first(id: entity.id)
        rebuild_entity(db_record)
      end

      def self.find_all_by_country(country_name)
        # SELECT * FROM `trending_lists` LEFT JOIN `countries`
        # ON (`countries`.`id` = `trending_lists`.`belonging_country_id`)
        # WHERE (`name` = `country_name`)
        db_lists =  Database::HotVideosListOrm
                    .left_join(:countries, id: :belonging_country_id)
                    .where(name: country_name)
        rebuild_many(db_lists)
      end

      def self.find_all_with_video(video_title)
        # SELECT * FROM `trending_lists` LEFT JOIN `youtube_videos`
        # ON (`youtube_videos`.`id` = `trending_lists`.`video_id`?)
        # WHERE (`title` = `video_title`)
      end

      def self.find_or_create(entity)
        find(entity) || create(entity)
      end

      def self.create(entity)
        raise 'Hot videos list already exists' if find(entity)

        db_list = HotVideosListCreateHelper.new(entity).call
        rebuild_entity(db_list)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::HotVideosList.new(
          db_record.to_hash.merge(
            belonging_country: Countries.rebuild_entity(db_record.belonging_country),
            videos: HotVideos.rebuild_many(db_record.videos)
          )
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_member|
          HotVideosLists.rebuild_entity(db_member)
        end
      end

      private_class_method :rebuild_entity, :rebuild_many

      # Helper class to create trending_list entity,
      # also check its belonging country & videos on it from the databases
      class HotVideosListCreateHelper
        def initialize(entity)
          @entity = entity
        end

        def create_entity
          Database::HotVideosListOrm.create(@entity.to_attr_hash)
        end

        def call
          belonging_country = Countries.find_or_create(@entity.belonging_country)

          create_entity.tap do |db_list|
            db_list.update(belonging_country: belonging_country)

            @entity.videos.each do |video|
              db_list.add_video(HotVideos.find_or_create(video))
            end
          end
        end
      end
    end
  end
end
