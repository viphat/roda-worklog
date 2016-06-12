App::Main.route('logs', 'api') do |r|
  r.post do
    halt_request(400, { error: "Yêu cầu không hợp lệ." }) if r["content"].nil?
    token = r.env["HTTP_AUTHORIZATION"]
    access_token_validate(token.gsub('Bearer ',''))
    require_current_user
    log = Log.create(
      content: r["content"],
      user_id: @current_user.id
    )
    halt_request(500, { error: "Internal Server Error." }) if log.nil?
    response.status = 201
    {
      success: true,
      id: log.id
    }
  end
end