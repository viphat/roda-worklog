# ./migrate/001_create_teams.rb

Sequel.migration do
  change do
    create_table(:teams) do
      primary_key :id, unique: true
      String :name, null: false
      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end
  end
end