# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'top_video_representer'

module YouTubeTrendingMap
  module Representer
    # Represents folder summary about repo's folder
    class GlobalTopVideosList < Roar::Decorator
      include Roar::JSON

      property :type
      property :count
      collection :videos, extend: Representer::TopVideo, class: OpenStruct
    end
  end
end
