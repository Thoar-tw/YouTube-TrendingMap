# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:popular_list_videos) do
      primary_key %i[popular_list_id youtube_video_id]
      foreign_key :popular_list_id, :popular_lists
      foreign_key :youtube_video_id, :youtube_videos

      index %i[popular_list_id youtube_video_id]
    end
  end
end
