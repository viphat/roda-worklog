# ./models/log.rb

class Log < Sequel::Model
  many_to_one :user
end