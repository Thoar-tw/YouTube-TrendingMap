# frozen_string_literal: true

module YouTubeTrendingMap
  module Entity
    # Entity for ranked trending videos in the gloal world
    class GlobalRanking
      include Mixins::RankingCalculator
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
