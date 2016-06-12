App::Main.route('users', 'api') do |r|
  r.get 'info' do
    # ap r.env
    token = r.env["HTTP_AUTHORIZATION"]
    @user = User.authenticate_or_request_with_token(token.gsub('Bearer ',''))
    render('users/info')
  end
  r.post 'login' do
    # ap r.env
    response.status = 200
    if user = User.authenticate(r["email"], r["password"])
      session[:user_id] = user.id
      puts user.id
      {
        success: true,
        message: "Login successful!",
        auth_token: user.auth_token
      }
    else
      {
        success: false,
        message: "Email/Mật khẩu không chính xác"
      }
    end
  end
end