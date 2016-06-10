require "roda"
require "dotenv"
require "slim"

Dotenv.load!

module App
  class Main < Roda
    raise 'Ruby should be >= 2.3' unless RUBY_VERSION.to_f >= 2.3
    use Rack::Session::Cookie, :secret => ENV.fetch("WORKLOG_SECRET")
    # use Rack::Protection

    plugin :render, engine: "slim"
    plugin :multi_route
    plugin :json
    plugin :all_verbs

    Dir['./routes/*.rb'].each { |f| require f }
    Dir['./routes/*/*.rb'].each { |f| require f }
    require './routes/api/logs.rb'

    route do |r|
      r.multi_route do
        response.status = 404
        {
          message: "Invalid Request"
        }
      end
      r.root do
        response.status = 200
        {
          name: "UBrand WorkLog Assistant",
          tagline: "Simple Logging for UBrand Team",
          version: "0.0.1"
        }
      end
    end

  end
end