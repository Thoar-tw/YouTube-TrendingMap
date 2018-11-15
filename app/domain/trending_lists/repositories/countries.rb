# frozen_string_literal: true

module YouTubeTrendingMap
  module Repository
    # Repository for Countries
    class Countries
      def self.find_country_name(name)
        db_record = Database::CountryOrm.first(name: name)
        rebuild_entity(db_record)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Country.new(
          id:         db_record.id,
          place_id:   db_record.place_id,
          name:       db_record.name,
          latitude:   db_record.latitude,
          longitude:  db_record.longitude
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_member|
          Countries.rebuild_entity(db_member)
        end
      end

      def self.find_or_create(entity)
        Database::CountryOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
