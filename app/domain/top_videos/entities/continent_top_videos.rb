# frozen_string_literal: true

# exactly trending videos from youtube api query
require_relative '../values/country.rb'
require_relative 'youtube_video.rb'

module YouTubeTrendingMap
  module Entity
    # Domain entity for Youtube trending lists
    class ContinentTopVideos
      include Mixins::TopVideosMerger

      attribute :id,                  Integer.optional
      attribute :count,               Strict::Integer
      attribute :belonging_continent, Strict::String
      attribute :videos,              Strict::Array.of(YoutubeVideo)

      def to_attr_hash
        to_hash.reject { |key, _| %i[id videos].include? key }
      end
    end
  end
end
