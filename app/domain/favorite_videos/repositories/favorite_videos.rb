# frozen_string_literal: true

module YouTubeTrendingMap
  module FavoriteVideosRepository
    # Repository for Countries
    class FavoriteVideos
      def self.all
        Database::FavoriteVideoOrm.all.map do |db_record|
          rebuild_entity(db_record)
        end
      end

      def self.find_title(title)
        rebuild_entity Database::FavoriteVideoOrm.first(title: title)
      end

      def self.delete_video(origin_id)
        Database::FavoriteVideoOrm.find(origin_id: origin_id).delete
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::FavoriteVideo.new(
          id: db_record.id,
          origin_id: db_record.origin_id,
          title: db_record.title,
          channel_title: db_record.channel_title,
          view_count: db_record.view_count,
          embed_link: db_record.embed_link
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_record|
          FavoriteVideos.rebuild_entity(db_record)
        end
      end

      def self.find_or_create(entity)
        Database::FavoriteVideoOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
