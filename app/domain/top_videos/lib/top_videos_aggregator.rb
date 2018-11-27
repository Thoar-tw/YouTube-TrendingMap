# frozen_string_literal: true

module YouTubeTrendingMap
  module Mixins
    # line credit calculation methods
    module TopVideosAggregator
      def aggregate(videos_list)
        # same_continent_top_videos =
        #   country_top_videos_array.select do |top_videos_list|
        #     belonging_continent(top_videos_list.region_code) == continent
        #   end
        videos = []
        videos_list.each do |list|
          list.videos.each do |video|
            videos << video
          end
        end
        puts ">> in aggregator"
        videos.each do |video|
          puts video.origin_id
        end

        videos = remove_duplicates(videos)
        puts ">> after removing duplicates"
        videos.each do |video|
          puts video.origin_id
        end

        videos = sort_by_view_counts(videos)
        puts ">> after sorting"
        videos.each do |video|
          puts video.origin_id
        end

        videos
      end

      def remove_duplicates(videos)
        videos.uniq(&:origin_id)
      end

      def sort_by_view_counts(videos)
        videos.sort_by(&:view_count).reverse
      end
    end
  end
end
