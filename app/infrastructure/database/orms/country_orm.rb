# frozen_string_literal: true

module APILirary
  module Database
    # Object Relational Mapper for Project Entities
    class CountryOrm < Sequel::Model(:countries)
      one_to_many :local_popular_lists,
                  class: :'APILirary::Database::PopularListOrm',
                  key: :belonging_country_id

      plugin :timestamps, update_on_create: true
    end
  end
end
