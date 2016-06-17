module MailHelpers
  def get_users_logs
    @begin_date = Time.now.beginning_of_day
    @end_date = Time.now.end_of_day
    @date_str = Time.now.beginning_of_day.strftime("%d-%m-%Y")
    team = Team.order(:id).first
    @users = User.where(team_id: team.id).order(:id).all
  end
end
