# frozen_string_literal: true

module APILirary
  module Database
    # Object Relational Mapper for Project Entities
    class PopularListOrm < Sequel::Model(:popular_lists)
      many_to_one   :belonging_country,
                    class: :'APILirary::Database::CounrtyOrm'

      many_to_many  :on_list_videos,
                    class: :'APILirary::Database::YoutubeVideoOrm',
                    join_table: :popular_list_videos,
                    left_key: :popular_list_id, right_key: :youtube_video_id

      plugin :timestamps, update_on_create: true
    end
  end
end
