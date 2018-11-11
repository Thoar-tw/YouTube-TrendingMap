module YouTubeTrendingMap
  module Mixins
    # line credit calculation methods
    module SortHelper
      def list_selection
      # TO DO select top ten videos from different countries (same continent) to sort
      end
      def sort_by_view_counts
        trending_list.sort()
      end
    end
  end
end