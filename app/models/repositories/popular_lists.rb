# frozen_string_literal: true

module YouTubeTrendingMap
  module Repository
    # Repository for Countries
    class PopularLists
      def self.find_id(id)
        rebuild_entity Database::PopularListOrm.first(id: id)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Country.new(
          id:         db_record.id,
          count:      db_record.count,
          videos:     db_record.videos
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_member|
          PopularLists.rebuild_entity(db_member)
        end
      end

      private_class_method :rebuild_entity, :rebuild_many
    end
  end
end
