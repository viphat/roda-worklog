# ./migrate/002_create_users.rb

Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id, unique: true
      String :name, null: false
      String :email, unique: true, null: false, index: true
      String :password, null: false
      String :role, null: false, default: 'member'
      foreign_key :team_id, :teams, on_delete: :cascade, on_update: :cascade
    end
  end
end