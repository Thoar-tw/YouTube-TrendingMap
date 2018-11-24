# frozen_string_literal: true

module YouTubeTrendingMap
  module TopVideosRepository
    # Repository for Countries
    class GlobalTopVideosLists
      def self.find_title(title)
        rebuild_entity Database::HotVideoOrm.first(title: title)
      end

      def self.find_channel_title(channel_title)
        rebuild_entity Database::HotVideoOrm.first(channel_title: channel_title)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::HotVideo.new(
          id: db_record.id,
          count: db_record.count,
          videos: db_record.videos
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_record|
          HotVideos.rebuild_entity(db_record)
        end
      end

      def self.find_or_create(entity)
        Database::HotVideoOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
