# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:popular_lists) do
      primary_key :id
      foreign_key :belonging_country_id, :countries

      Integer     :count

      DateTime    :create_at
      DateTime    :update_at
    end
  end
end
