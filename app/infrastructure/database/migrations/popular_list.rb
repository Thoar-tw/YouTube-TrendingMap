Sequel.migration do
  change do 
    create_table(:popular_list)do 
      primary_key :[:youtube_videos_id,:country_id]
      foreign_key :youtube_videos_id, :youtube_videos
      foreign_key :country_id,  :country 
      
      index[:youtube_videos_id,:country_id]
    end
  end
end