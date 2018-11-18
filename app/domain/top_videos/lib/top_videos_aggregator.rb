# frozen_string_literal: true

module YouTubeTrendingMap
  module Mixins
    # line credit calculation methods
    module TopVideosAggregator
      def aggregate_all(continent_top_videos)
      end

      def aggregate_from_same_continent(country_top_videos_array, continent)
        same_continent_top_videos =
          country_top_videos_array.select do |top_videos_list|
            belonging_continent(top_videos_list.region_code) == continent
          end

        remove_duplicates(same_continent_top_videos)
      end

      def remove_duplicates(top_videos)
      end

      def belonging_continent(country_code)
        CONTINENT_COUNTRY_CODES.each do |continent, countries|
          return continent if countries.key?(country_code)
        end
      end

      def sort_by_view_counts
      end
    end
  end
end
