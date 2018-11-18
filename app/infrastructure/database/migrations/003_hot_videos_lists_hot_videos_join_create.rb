# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:hot_videos_lists_hot_videos) do
      primary_key %i[hot_videos_list_id hot_video_id]
      foreign_key :hot_videos_list_id, :hot_videos_lists
      foreign_key :hot_video_id, :hot_videos

      index %i[hot_videos_list_id hot_video_id]
    end
  end
end
