require 'dry-types'
require 'dry-struct'
require_relative 'VideoViewCounts'

module YouTubeTrendingMap
  module Entity
    # Entity for a single line of code contributed by a team-member
    class GlobalTrending < Dry::Struct
      include Mixins::SortHelper
      attr_reader :trending_list

      def initialize(trending_list:)
        @trending_list = trending_list
      end
            
      # don't know if redundant
      def sort_view_counts
        trending_list.sort_by_view_counts
      end

    end
  end
end