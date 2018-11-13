# frozen_string_literal: true

module YouTubeTrendingMap
  module Database
    # Object Relational Mapper for TrendingList Entities
    class TrendingListOrm < Sequel::Model(:trending_lists)
      many_to_one   :belonging_country,
                    class: :'YouTubeTrendingMap::Database::CountryOrm'

      many_to_many  :on_list_videos,
                    class: :'YouTubeTrendingMap::Database::YoutubeVideoOrm',
                    join_table: :trending_list_videos,
                    left_key: :trending_list_id, right_key: :youtube_video_id

      plugin :timestamps, update_on_create: true
    end
  end
end
