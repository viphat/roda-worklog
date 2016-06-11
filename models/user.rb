# ./models/user.rb

class User < Sequel::Model
  # User.plugin :timestamps, create: :created_at, update: :updated_at, update_on_create: true
  one_to_many :logs, on_delete: :cascade
  attr_accessor :original_password, :password_confirmation

  def validate
    super
    validates_presence :original_password
    validates_length_range 6..15, :original_password
    validates_presence :password_confirmation
    errors.add(:password_confirmation, "Mật khẩu xác nhận không khớp") if original_password != password_confirmation
  end

  def before_save
    super
    encrypt_password
  end


private

  def encrypt_password
    self.password = BCrypt::Password.create(original_password)
  end

end