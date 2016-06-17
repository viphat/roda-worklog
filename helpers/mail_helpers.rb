module MailHelpers
  def get_users_logs
    @begin_date = (Time.now - 1.day).beginning_of_day
    @end_date = (Time.now - 1.day).end_of_day
    @date_str = @begin_date.strftime("%d-%m-%Y")
    team = Team.order(:id).first
    @users = User.where(team_id: team.id).order(:id).all
  end
end
