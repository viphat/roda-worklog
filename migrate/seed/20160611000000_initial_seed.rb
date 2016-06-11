Sequel.seed("development", "test") do
  def run
    team = Team.create(
      name: "Developer Team"
    )
    User.create(
      name: "Dương Vì Phát",
      email: "viphat@ubc.vn",
      original_password: '123456',
      password_confirmation: '123456',
      role: "member",
      team_id: team.id
    )
  end
end