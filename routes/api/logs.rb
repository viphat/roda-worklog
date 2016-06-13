App::Main.route('logs', 'api') do |r|
  r.post do
    # Không tương thích với Slack
    # halt_request(400, { error: "Yêu cầu không hợp lệ." }) if r["content"].nil?
    # token = r.env["HTTP_AUTHORIZATION"]
    # access_token_validate(token.gsub('Bearer ',''))
    # require_current_user
    # log = Log.create(
    #   content: r["content"],
    #   user_id: @current_user.id
    # )
    # halt_request(500, { error: "Internal Server Error." }) if log.nil?
    # response.status = 201
    # {
    #   success: true,
    #   id: log.id
    # }

    halt_request(400, { error: "Yêu cầu không hợp lệ." }) if r["content"].nil?
    response.status = 200
    slack_user_id = r["user_id"]
    user = User.find_by_slack_user_id(slack_user_id)
    halt_request(400, { error: "Yêu cầu không hợp lệ." }) if user.nil?
    log = Log.create(
      content: r["text"],
      user_id: user.id
    )
    halt_request(500, { error: "Internal Server Error." }) if log.nil?
    {
      text: "Server đã nhận được log của bạn."
    }
  end
end