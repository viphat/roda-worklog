require 'roda'
require 'dotenv'
require 'slim'
require 'sequel'
require 'rack-protection'

Dotenv.load!
database = ENV.fetch("WORKLOG_DATABASE")
user = ENV.fetch("PG_USER")
password = ENV.fetch("PG_PASSWORD")
host = ENV.fetch("PG_HOST")
DB = Sequel.connect(adapter: "postgres", database: database, host: host, user: user, password: password)

module App
  class Main < Roda
    raise 'Ruby should be >= 2.3' unless RUBY_VERSION.to_f >= 2.3
    use Rack::Session::Cookie, :secret => ENV.fetch("WORKLOG_SECRET")
    use Rack::Protection

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