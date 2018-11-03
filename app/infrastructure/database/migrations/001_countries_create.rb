# frozen_string_literal: false

Sequel.migration do
  change do
    create_table(:countries) do
      primary_key :id

      Integer     :place_id
      String      :name
      Float       :latitude
      Float       :longitude

      DateTime    :create_at
      DateTime    :update_at
    end
  end
end
