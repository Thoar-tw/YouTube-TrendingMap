# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative 'VideoViewCounts'

module YouTubeTrendingMap
  module Entity
    # Entity for trending videos in a country
    class CountryTrending < Dry::Struct
      include Mixins::SortHelper
      attr_reader :trending_list,:area

      def initialize(trending_list:,area:)
        @trending_list = trending_list
        @area = area
      end

      # don't know if redundant
      def sort_view_counts
        trending_list.sort_by_view_counts
      end
    end
  end
end
