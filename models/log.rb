# ./models/log.rb

class Log < Sequel::Model
  # Log.plugin :timestamps, create: :created_at, update: :updated_at, update_on_create: true
  many_to_one :user
end