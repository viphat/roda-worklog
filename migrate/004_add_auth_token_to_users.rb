# ./migrate/004_add_auth_token_to_users.rb

Sequel.migration do
  change do
    add_column :users, :auth_token, String
    add_index :users, :auth_token, unique: true
  end
end