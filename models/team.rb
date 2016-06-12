# ./models/team.rb

class Team < Sequel::Model
  one_to_many :users, on_delete: :cascade
end