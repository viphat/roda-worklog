App::Main.route('users', 'api') do |r|
  r.post 'login' do
    ap r.env
    response.status = 200
    if user = User.authenticate(r["email"], r["password"])
      session[:user_id] = user.id
      puts user.id
      {
        success: true,
        message: "Login successful!"
      }
    else
      {
        success: false,
        message: "Email/Mật khẩu không chính xác"
      }
    end
  end
end