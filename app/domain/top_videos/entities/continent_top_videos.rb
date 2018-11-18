# frozen_string_literal: true

require_relative 'top_video.rb'

module YouTubeTrendingMap
  module Entity
    # Domain entity for Youtube trending lists
    class ContinentTopVideos
      include Mixins::TopVideosAggregator

      attribute :id,                  Integer.optional
      attribute :count,               Strict::Integer
      attribute :belonging_continent, Strict::String
      attribute :videos,              Strict::Array.of(TopVideo)

      def to_attr_hash
        to_hash.reject { |key, _| %i[id videos].include? key }
      end
    end
  end
end
