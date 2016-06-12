App::Main.route('api') do |r|
  r.multi_route("api")
  r.get do
    {
      text: "Welcome from /api"
    }
  end
end