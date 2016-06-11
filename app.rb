require 'roda'
require 'dotenv'
require 'slim'
require 'sequel'
require 'sequel/extensions/seed'
require 'rack/protection'
require 'bcrypt'

Dotenv.load!
database = ENV.fetch("WORKLOG_DATABASE")
user = ENV.fetch("PG_USER")
password = ENV.fetch("PG_PASSWORD")
host = ENV.fetch("PG_HOST")

begin
  DB = Sequel.connect(adapter: "postgres", database: database, host: host, user: user, password: password)
rescue Exception
  DB = Sequel.connect(adapter: "postgres", host: host, user: user, password: password)
end

Sequel.extension :seed

module App
  class Main < Roda
    raise 'Ruby should be >= 2.3' unless RUBY_VERSION.to_f >= 2.3
    use Rack::Session::Cookie, :secret => ENV.fetch("WORKLOG_SECRET")
    use Rack::Protection

    plugin :csrf
    plugin :render, engine: "slim"
    plugin :multi_route
    plugin :json
    plugin :all_verbs

    Sequel::Model.plugin :validation_helpers
    # Default Timestamps
    Sequel::Model.plugin :timestamps, create: :created_at, update: :updated_at, update_on_create: true

    Dir['./routes/**/*.rb'].each { |f| require f }
    begin
      Dir['./models/**/*.rb'].each { |f| require f } if DB.test_connection
    rescue Exception
      # Nothing
    end

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