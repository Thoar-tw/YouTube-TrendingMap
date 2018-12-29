# frozen_string_literal: true

module YouTubeTrendingMap
  module Entity
    # Youtube trending videos in a certain region
    class FavoriteVideo < Dry::Struct
      include Dry::Types.module

      attribute :origin_id,       Strict::String
      attribute :title,           Strict::String
      attribute :channel_title,   Strict::String
      attribute :view_count,      Strict::Integer
      attribute :embed_link,      Strict::String.constrained(
        format: %r{https\:\/\/www\.youtube\.com\/embed\/(.*?)}
      )

      def to_attr_hash
        to_hash.reject { |key, _| [:id].include? key }
      end
    end
  end
end
