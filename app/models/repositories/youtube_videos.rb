# frozen_string_literal: true

module APILibrary
  module Repository
    # Repository for Countries
    class YoutubeVideos
      def self.find_id(id)
        rebuild_entity Database::YoutubeVideoOrm.first(id: id)
      end

      def self.find_title(title)
        rebuild_entity Database::YoutubeVideoOrm.first(title: title)
      end

      def self.find_channel_title(channel_title)
        rebuild_entity Database::YoutubeVideoOrm.first(channel_title: channel_title)
      end

      def self.rebuild_entity(db_record) # rubocop:disable Metrics/MethodLength
        return nil unless db_record

        Entity::YoutubeVideo.new(
          id:             db_record.id,
          origin_id:      db_record.origin_id,
          publish_time:   db_record.publish_time,
          title:          db_record.title,
          description:    db_record.description,
          channel_title:  db_record.channel_title,
          view_count:     db_record.view_count,
          like_count:     db_record.like_count,
          dislike_count:  db_record.dislike_count,
          embed_link:     db_record.embed_link
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_member|
          YoutubeVideos.rebuild_entity(db_member)
        end
      end

      def self.db_find_or_create(entity)
        Database::YoutubeVideoOrm.find_or_create(entity.to_attr_hash)
      end

      private_class_method :rebuild_entity, :rebuild_many, :db_find_or_create
    end
  end
end
