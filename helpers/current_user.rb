module CurrentUser
  attr_accessor :token

  def access_token_validate(token)
    self.token = token
  end

  def current_user
    @current_user = User.authenticate_or_request_with_token(self.token)
  end

  def require_current_user
    halt_request(403, {error: 'Access denied'}) if current_user.nil?
  end

end