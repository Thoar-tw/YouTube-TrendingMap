Sequel.migration do
  change do 
    create_table(:country)do 
      primary_key :id
      String      :place_id
      Float       :latitude 
      Float       :longitude
      String      :channel_title
      Array       :boundaries
    
      DateTime    :create_at
      DateTime    :update_at    
    end
  end
end