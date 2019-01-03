# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'favorite_video_representer'

module YouTubeTrendingMap
  module Representer
    # Represents list of FavoriteVideo for API output
    class FavoriteVideosList < Roar::Decorator
      include Roar::JSON

      collection :videos, extend: Representer::FavoriteVideo, class: OpenStruct
    end
  end
end
