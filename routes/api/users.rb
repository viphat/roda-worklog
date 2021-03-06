App::Main.route('users', 'api') do |r|

  r.get 'info' do
    token = r.env["HTTP_AUTHORIZATION"]
    access_token_validate(token.gsub('Bearer ',''))
    require_current_user
    render('users/info')
  end

  r.post 'verify' do
    halt_request(400, { text: "Yêu cầu không hợp lệ." }) if r["text"].nil?
    response.status = 200
    slack_user_id = r["user_id"]
    input = r["text"]
    email = input.split(" ")[0]
    password = input.split(" ")[1]
    user = User.authenticate(email, password)
    if r['token'] == SLACK_TOKEN_FOR_VERIFY_USER && user
      user.update_slack_user_id(slack_user_id)
      {
        text: "Xác thực thành công. Bạn có thể gửi worklog bằng lệnh /log!"
      }
    else
      response.status = 403
      {
        text: "Xác thực không thành công. Vui lòng thử lại!"
      }
    end
  end

  r.post 'login' do
    # ap r.env
    response.status = 200
    if user = User.authenticate(r["email"], r["password"])
      session[:user_id] = user.id
      user = User.where(email: r["email"]).first
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
