# frozen_string_literal: false

module YouTubeTrendingMap
  module Entity
    # Domain entity for Youtube popular lists
    class PopularList < Dry::Struct
      include Dry::Types.module

      attribute :id,        Integer.optional
      attribute :count,     Strict::Integer
      attribute :videos,    Strict::Array.of(YoutubeVideo)
    end
  end
end
