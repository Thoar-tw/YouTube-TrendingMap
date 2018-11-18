# frozen_string_literal: true

require_relative 'top_video.rb'

module YouTubeTrendingMap
  module Entity
    # Domain entity for Youtube trending lists
    class GlobalTopVideos
      include Mixins::TopVideosAggregator

      attr_reader :continent_top_videos

      attribute :id,                  Integer.optional
      attribute :count,               Strict::Integer
      attribute :videos,              Strict::Array.of(TopVideo)

      def to_attr_hash
        to_hash.reject { |key, _| %i[id videos].include? key }
      end
    end
  end
end
