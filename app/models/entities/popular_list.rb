# frozen_string_literal: false

module APILibrary
  module Entity
    # Domain entity for Youtube popular lists
    class PopularList < Dry::Struct
      include Dry::Types.module

      attribute :count,     Strict::Integer
      attribute :videos,    Strict::Array.of(YoutubeVideo)
    end
  end
end
