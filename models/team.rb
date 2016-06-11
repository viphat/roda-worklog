# ./models/team.rb

class Team < Sequel::Model
  # Team.plugin :timestamps, create: :created_at, update: :updated_at, update_on_create: true
  one_to_many :users, on_delete: :cascade
end