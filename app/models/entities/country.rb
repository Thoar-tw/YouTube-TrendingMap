# frozen_string_literal: false

module APILibrary
  module Entity
    # Domain entity for OSM countries
    class Country < Dry::Struct
      include Dry::Types.module

      attribute :place_id,        Strict::String
      attribute :latitude,        Strict::Float
      attribute :longitude,       Strict::Float
      attribute :boundaries,      Strict::Array
    end
  end
end
