# frozen_string_literal: true

module YouTubeTrendingMap
  module Mixins
    # line credit calculation methods
    module TopVideosAggregator
      def aggregate(top_videos_array)
        # same_continent_top_videos =
        #   country_top_videos_array.select do |top_videos_list|
        #     belonging_continent(top_videos_list.region_code) == continent
        #   end

        remove_duplicates(top_videos_array)
      end

      def remove_duplicates(top_videos)
      end

      # def belonging_continent(country_code)
      #   CONTINENT_COUNTRY_CODES.each do |continent, countries|
      #     return continent if countries.key?(country_code)
      #   end
      # end

      def sort_by_view_counts
      end
    end
  end
end
