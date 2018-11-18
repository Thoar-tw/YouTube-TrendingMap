# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:youtube_videos) do
      primary_key :id

      String      :origin_id, unique: true, null: false
      String      :title, unique: true, null: false
      String      :publish_time
      String      :description
      String      :channel_title
      Integer     :view_count
      Integer     :like_count
      Integer     :dislike_count
      String      :embed_link

      DateTime    :create_at
      DateTime    :update_at
    end
  end
end
