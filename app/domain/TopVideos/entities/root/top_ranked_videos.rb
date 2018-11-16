
module YouTubeTrendingMap
  module Entity
    # Entity for ranked trending videos in a continent
    class TopRankedVideos
      include Mixins::trendingDecider
      attr_reader :trending_list, :continent

      def initialize(trending_list:, continent:)
        @trending_list = trending_list
        @continent = continent
      end

      # don't know if redundant
      def decide_interested_video_type
        
      def sort_view_counts
        trending_list.sort_by_view_counts
      end
    end
  end
end