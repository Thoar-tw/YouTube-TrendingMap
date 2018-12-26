# frozen_string_literal: true

require_relative 'top_video.rb'

module YouTubeTrendingMap
  module Entity
    # Domain entity for Youtube trending lists
    class GlobalTopVideosList < Dry::Struct
      include Dry::Types.module

      attribute :id,                  Integer.optional
      attribute :type,                Strict::String
      attribute :count,               Strict::Integer
      attribute :videos,              Strict::Array.of(TopVideo)

      def to_attr_hash
        to_hash.reject { |key, _| %i[id videos].include? key }
      end
    end
  end
end
