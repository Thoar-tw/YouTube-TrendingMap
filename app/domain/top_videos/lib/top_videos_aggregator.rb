# frozen_string_literal: true

module YouTubeTrendingMap
  module Mixins
    # line credit calculation methods
    module TopVideosAggregator
      def aggregate(videos_list)
        videos = []
        videos_list.each do |list|
          list.videos.each do |video|
            videos << video
          end
        end
        puts '>> in aggregator'
        videos.each do |video|
          puts video.origin_id
        end

        videos = remove_duplicates(videos)
        puts '>> after removing duplicates'
        videos.each do |video|
          puts video.origin_id
        end

        videos = sort_by_view_counts(videos)
        puts '>> after sorting'
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
