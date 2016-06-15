Sequel.seed(:development, :production, :test) do
  def run
    team = Team.create(
      name: "Developers Team"
    )

    User.create(
      name: "Dương Vì Phát",
      email: "viphat@ubc.vn",
      original_password: 'F7YJiPpt',
      password_confirmation: 'F7YJiPpt',
      role: "member",
      team_id: team.id
    )

    User.create(
      name: "Phùng Đông Hưng",
      email: "donghung@ubc.vn",
      original_password: 'wWCJTUj9',
      password_confirmation: 'wWCJTUj9',
      role: "member",
      team_id: team.id
    )

    User.create(
      name: "Dương Hoàng Nhựt",
      email: "hoangnhut@ubc.vn",
      original_password: 'rSYPz1qC',
      password_confirmation: 'rSYPz1qC',
      role: "member",
      team_id: team.id
    )

    User.create(
      name: "Nguyễn Đức Long",
      email: "duclong@ubc.vn",
      original_password: 'PBQPTp28',
      password_confirmation: 'PBQPTp28',
      role: "member",
      team_id: team.id
    )

    owner_team = Team.create(
      name: "Product Owner"
    )

    User.create(
      name: "Đinh Hải Đăng",
      email: "dinhhaidang@ubc.vn",
      original_password: "YAigRzj9",
      password_confirmation: "YAigRzj9",
      role: "leader",
      team_id: owner_team.id
    )
  end
end
