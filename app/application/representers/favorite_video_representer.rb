# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module YouTubeTrendingMap
  module Representer
    # Represents HotVideo information for API output
    class FavoriteVideo < Roar::Decorator
      include Roar::JSON

      property :origin_id
      property :title
      property :channel_title
      property :view_count
      property :embed_link
    end
  end
end
