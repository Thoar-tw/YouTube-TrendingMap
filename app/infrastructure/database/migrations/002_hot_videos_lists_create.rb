# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:hot_videos_lists) do
      primary_key :id

      Integer     :count
      String      :belonging_country

      DateTime    :create_at
      DateTime    :update_at
    end
  end
end
