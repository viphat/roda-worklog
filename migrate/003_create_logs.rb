# ./migrate/003_create_logs.rb

Sequel.migration do
  change do
    create_table(:logs) do
      primary_key :id, unique: true
      foreign_key :user_id, :users, on_delete: :cascade, on_update: :cascade, index: true
      String :content, text: true, null: false
      DateTime :created_at, null: false
    end
  end
end