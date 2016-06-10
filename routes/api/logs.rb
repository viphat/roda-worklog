App::Main.route('logs', 'api') do |r|
  r.get do
    {
      text: "Welcome from /api/logs"
    }
  end
end