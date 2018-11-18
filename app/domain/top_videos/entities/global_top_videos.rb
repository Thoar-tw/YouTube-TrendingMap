# frozen_string_literal: true

require_relative 'top_video.rb'

module YouTubeTrendingMap
  module Entity
    # Domain entity for Youtube trending lists
    class GlobalTopVideos
      include Mixins::TopVideosAggregator

      attr_reader :continent_top_videos

      # attribute :id,                  Integer.optional
      # attribute :count,               Strict::Integer
      # attribute :videos,              Strict::Array.of(TopVideo)
    end
  end
end
