App::Main.route('users', 'api') do |r|
  r.get do
    {
      text: "Welcome from /api/users"
    }
  end
end