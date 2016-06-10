App::Main.route('api') do |r|
  r.multi_route("api") do
    response.status = 404
    {
      message: "Invalid Request"
    }
  end
  r.get do
    {
      text: "Welcome from /api"
    }
  end
end