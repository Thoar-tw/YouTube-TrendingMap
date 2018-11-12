# frozen_string_literal: false

module YouTubeTrendingMap
  module Entity
    # Domain entity for Youtube popular lists
    class PopularList < Dry::Struct
      include Dry::Types.module

      attribute :id,                  Integer.optional
      attribute :count,               Strict::Integer
      attribute :belonging_country,   Country
      attribute :videos,              Strict::Array.of(YoutubeVideo)

      def to_attr_hash
        to_hash.reject { |key, _| %i[id belonging_country videos].include? key }
      end
    end
  end
end
