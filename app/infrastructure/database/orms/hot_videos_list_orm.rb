# frozen_string_literal: true

module YouTubeTrendingMap
  module Database
    # Object Relational Mapper for HotVideosList Entities
    class HotVideosListOrm < Sequel::Model(:hot_videos_lists)
      many_to_one   :belonging_country,
                    class: :'YouTubeTrendingMap::Database::CountryOrm'

      many_to_many  :videos,
                    class: :'YouTubeTrendingMap::Database::HotVideoOrm',
                    join_table: :on_hot_list_videos,
                    left_key: :hot_videos_list_id, right_key: :hot_video_id

      plugin :timestamps, update_on_create: true
    end
  end
end
