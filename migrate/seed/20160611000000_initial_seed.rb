Sequel.seed(:development, :test) do
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

    owner_team = Team.create(
      name: "Product Owner"
    )

    User.create(
      name: "Đinh Hải Đăng",
      email: "dinhhaidang@ubc.vn",
      original_password: "123456",
      password_confirmation: "123456",
      role: "leader",
      team_id: owner_team.id
    )
  end
end