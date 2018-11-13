# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:trending_list_videos) do
      primary_key %i[trending_list_id youtube_video_id]
      foreign_key :trending_list_id, :trending_lists
      foreign_key :youtube_video_id, :youtube_videos

      index %i[trending_list_id youtube_video_id]
    end
  end
end
