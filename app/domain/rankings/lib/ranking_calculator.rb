# frozen_string_literal: true

module YouTubeTrendingMap
  module Mixins
    # Trending video rankings calculation methods
    module RankingCalaulator
      def list_selection
        # TODO: select top ten videos from different countries (same continent) to sort
      end

      def sort_by_view_counts
        trending_list.sort()
      end
    end
  end
end
