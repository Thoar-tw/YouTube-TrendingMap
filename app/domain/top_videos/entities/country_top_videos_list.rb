# frozen_string_literal: true

# exactly trending videos from youtube api query
require_relative 'country.rb'
require_relative 'top_video.rb'

module YouTubeTrendingMap
  module Entity
    # Domain entity for Youtube trending lists
    class CountryTopVideosList < Dry::Struct
      include Dry::Types.module

      attribute :id,                  Integer.optional
      attribute :type,                Strict::String
      attribute :count,               Strict::Integer
      attribute :belonging_country,   Strict::String
      attribute :videos,              Strict::Array.of(TopVideo)

      def to_attr_hash
        to_hash.reject { |key, _| %i[id videos].include? key }
      end
    end
  end
end
