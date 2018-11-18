# frozen_string_literal: true

module YouTubeTrendingMap
  module Database
    # Object Relational Mapper for HotVideo Entities
    class HotVideoOrm < Sequel::Model(:hot_videos)
      many_to_many  :hot_videos_lists_within,
                    class: :'YouTubeTrendingMap::Database::HotVideosListOrm',
                    join_table: :hot_videos_lists_hot_videos,
                    left_key: :hot_video_id, right_key: :hot_videos_list_id

      plugin :timestamps, update_on_create: true

      def self.find_or_create(video_info)
        first(title: video_info[:title]) || create(video_info)
      end
    end
  end
end
