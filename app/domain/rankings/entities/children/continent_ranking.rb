# frozen_string_literal: true

module YouTubeTrendingMap
  module Entity
    # Entity for ranked trending videos in a continent
    class ContinentRanking
      include Mixins::RankingCalculator
      attr_reader :trending_list, :continent

      def initialize(trending_list:, continent:)
        @trending_list = trending_list
        @continent = continent
      end

      # don't know if redundant
      def sort_view_counts
        trending_list.sort_by_view_counts
      end
    end
  end
end
