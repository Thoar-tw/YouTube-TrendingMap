# frozen_string_literal: true

module YouTubeTrendingMap
  module Database
    # Object Relational Mapper for HotVideo Entities
    class FavoriteVideoOrm < Sequel::Model(:favorite_videos)
      plugin :timestamps, update_on_create: true

      def self.find_or_create(video_info)
        puts 'inside orm find_or_create'
        first(origin_id: video_info[:origin_id]) || create(video_info)
      end
    end
  end
end
