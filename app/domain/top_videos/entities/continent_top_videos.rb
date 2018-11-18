# frozen_string_literal: true

require_relative 'top_video.rb'

module YouTubeTrendingMap
  module Entity
    # Domain entity for Youtube trending lists
    class ContinentTopVideos
      include Mixins::TopVideosAggregator

      # attribute :id,                  Integer.optional
      # attribute :count,               Strict::Integer
      # attribute :belonging_continent, Strict::String
      # attribute :videos,              Strict::Array.of(TopVideo)

    end
  end
end
