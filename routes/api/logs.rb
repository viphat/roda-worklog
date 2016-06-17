App::Main.route('logs', 'api') do |r|
  r.post 'show' do
    halt_request(400, { text: "Yêu cầu không hợp lệ." }) unless r["token"] == SLACK_TOKEN_FOR_LATEST_LOGS
    slack_user_id = r["user_id"]
    user = User.find_by_slack_user_id(slack_user_id)
    halt_request(400, { text: "Yêu cầu không hợp lệ." }) if user.nil?
    logs = Log.filter(user_id: user.id).order(:created_at).last(10)
    halt_request(200, { text: "Bạn chưa ghi nhận worklog nào." }) if logs.nil?
    built_text_arr = ["Top 10 worklogs gần nhất của bạn là:"]
    logs = logs.sort_by(&:id)
    logs.each do |log|
      built_text_arr.push("#{log.id}- *#{log.created_at.strftime('%d-%m-%Y %H:%M:%S')}* - #{log.content}")
    end
    halt_request(200, { text: "Bạn chưa ghi nhận worklog nào." }) if built_text_arr.length == 0
    response.status = 200
    {
      text: built_text_arr.join("\n")
    }
  end

  r.post 'update' do
    halt_request(400, { text: "Yêu cầu không hợp lệ." }) if r["text"].nil?
    halt_request(400, { text: "Yêu cầu không hợp lệ." }) unless r["token"] == SLACK_TOKEN_FOR_UPDATE_LOG
    slack_user_id = r["user_id"]
    user = User.find_by_slack_user_id(slack_user_id)
    halt_request(400, { text: "Yêu cầu không hợp lệ." }) if user.nil?
    id = r["text"].split(" ").first
    halt_request(400, { text: "Yêu cầu không hợp lệ." }) if id.nil?
    log = Log.where(id: id, user_id: user.id ).first
    halt_request(400, { error: "Yêu cầu không hợp lệ." }) if log.nil?
    halt_request(400, { error: "Yêu cầu không hợp lệ." }) if log.created_at < Time.now.beginning_of_day
    log[:content] = r["text"].split(" ").drop(1).join(" ")
    halt_request(400, { error: "Yêu cầu cập nhật worklog không thành công!" }) unless log.save_changes
    response.status = 200
    {
      text: "Cập nhật worklog thành công."
    }
  end

  r.post 'delete' do
    halt_request(400, { text: "Yêu cầu không hợp lệ." }) if r["text"].nil?
    halt_request(400, { text: "Yêu cầu không hợp lệ." }) unless r["token"] == SLACK_TOKEN_FOR_UPDATE_LOG
    slack_user_id = r["user_id"]
    id = r["text"].split(" ").join(" ").to_i
    user = User.find_by_slack_user_id(slack_user_id)
    halt_request(400, { text: "Yêu cầu không hợp lệ." }) if user.nil?
    log = Log.where(id: id, user_id: user.id ).first
    halt_request(400, { error: "Yêu cầu không hợp lệ." }) if log.nil?
    halt_request(400, { error: "Yêu cầu không hợp lệ." }) if log.created_at < Time.now.beginning_of_day
    halt_request(400, { error: "Yêu cầu xóa worklog thất bại." }) unless log.destroy
    response.status = 200
    {
      text: "Xóa worklog thành công."
    }
  end

  r.post 'create' do
    halt_request(400, { text: "Yêu cầu không hợp lệ." }) if r["text"].nil?
    halt_request(400, { text: "Yêu cầu không hợp lệ." }) unless r["token"] == SLACK_TOKEN_FOR_CREATE_LOG
    slack_user_id = r["user_id"]
    user = User.find_by_slack_user_id(slack_user_id)
    halt_request(400, { text: "Yêu cầu không hợp lệ." }) if user.nil?
    log = Log.create(
      content: r["text"],
      user_id: user.id
    )
    halt_request(500, { text: "Internal Server Error." }) if log.nil?
    response.status = 200
    {
      text: "Server đã nhận được worklog của bạn.\nID của *worklog* vừa tạo là *#{log.id}*.\nBạn có thể cập nhật/xóa các worklogs được tạo ra trong ngày."
    }
  end
end
