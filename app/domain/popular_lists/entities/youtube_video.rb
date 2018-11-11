# frozen_string_literal: false

module YouTubeTrendingMap
  module Entity
    # Domain entity for Youtube videos
    class YoutubeVideo < Dry::Struct
      include Dry::Types.module

      attribute :id,              Integer.optional
      attribute :origin_id,       Strict::String
      attribute :publish_time,    Strict::String.constrained(
        format: /(\d\d\d\d)-(\d\d)-(\d\d)T(\d\d):(\d\d):(\d\d).000Z/
      )
      attribute :title,           Strict::String
      attribute :description,     Strict::String
      attribute :channel_title,   Strict::String
      attribute :view_count,      Strict::Integer
      attribute :like_count,      Strict::Integer
      attribute :dislike_count,   Strict::Integer
      attribute :embed_link,      Strict::String.constrained(
        format: %r{https\:\/\/www\.youtube\.com\/embed\/(.*?)}
      )

      def to_attr_hash
        to_hash.reject { |key, _| [:id].include? key }
      end
    end
  end
end
