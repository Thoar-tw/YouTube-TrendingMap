# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module YouTubeTrendingMap
  module Representer
    # Represents HotVideoList information for API output
    class HotVideosList < Roar::Decorator
      include Roar::JSON

      property :count
      property :belonging_country
      collection :videos, extend: Representer::HotVideo, class: OpenStruct
    end
  end
end
