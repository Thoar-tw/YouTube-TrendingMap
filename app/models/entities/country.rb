# frozen_string_literal: false

module APILibrary
  module Entity
    # Domain entity for OSM countries
    class Country < Dry::Struct
      include Dry::Types.module

      attribute :place_id,        Strict::Integer
      attribute :name,            Strict::String
      attribute :latitude,        Strict::Float
      attribute :longitude,       Strict::Float
    end
  end
end
