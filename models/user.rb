# ./models/user.rb

class User < Sequel::Model
  one_to_many :logs, on_delete: :cascade
  many_to_one :team
  attr_accessor :original_password, :password_confirmation

  def validate
    super
    validates_unique :auth_token
    validates_presence :original_password
    validates_length_range 4..15, :original_password
    validates_presence :password_confirmation
    errors.add(:password_confirmation, "Mật khẩu xác nhận không khớp") if original_password != password_confirmation
  end

  def self.authenticate(email, password)
    user = filter(Sequel.function(:lower, :email) => Sequel.function(:lower, email)).first
    res = user && user.has_password?(password) ? user : nil
    User.where(id: user.id).update(auth_token: SecureRandom.hex) if res
    res
  end

  def update_slack_user_id(slack_user_id)
    User.where(id: self.id).update(slack_user_id: slack_user_id)
  end

  def self.authenticate_or_request_with_token(token)
    User.where(auth_token: token).first
  end

  def has_password?(password)
    BCrypt::Password.new(self.password) == password
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