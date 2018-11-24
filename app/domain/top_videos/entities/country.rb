# frozen_string_literal: true

module YouTubeTrendingMap
  module Entity
    # Domain entity for OSM countries
    class Country < Dry::Struct
      include Dry::Types.module

      attribute :id,              Integer.optional
      attribute :place_id,        Strict::Integer
      attribute :name,            Strict::String
      attribute :latitude,        Strict::Float
      attribute :longitude,       Strict::Float

      def to_attr_hash
        to_hash.reject { |key, _| [:id].include? key }
      end
    end
  end
end
