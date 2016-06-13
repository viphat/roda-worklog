# ./migrate/004_add_auth_token_to_users.rb

Sequel.migration do
  change do
    add_column :users, :slack_user_id, String
    add_index :users, :slack_user_id, unique: true
  end
end