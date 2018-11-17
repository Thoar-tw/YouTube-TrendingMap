# frozen_string_literal: true

module YouTubeTrendingMap
  module Mixins
    # Trending video rankings calculation methods
    module RankingCalculator
      def top_n(n)
      end

      def sort_by_view_counts
        trending_list.sort
      end

      def within_time_interval(days)
        
      end
    end
  end
end
