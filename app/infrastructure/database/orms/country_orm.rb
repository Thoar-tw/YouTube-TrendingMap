# frozen_string_literal: true

module YouTubeTrendingMap
  module Database
    # Object Relational Mapper for Country Entities
    class CountryOrm < Sequel::Model(:countries)
      one_to_many :local_trending_lists,
                  class: :'YouTubeTrendingMap::Database::TrendingListOrm',
                  key: :belonging_country_id

      plugin :timestamps, update_on_create: true

      def self.find_or_create(country_info)
        first(name: country_info[:name]) || create(country_info)
      end
    end
  end
end
