require 'roda'
require 'dotenv'
require 'slim'
require 'tilt/jbuilder'
require 'sequel'
require 'sequel/extensions/seed'
require 'rack/protection'
require 'bcrypt'
require 'logger'
require 'awesome_print'

Dotenv.load!

# Database
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

Dir[__dir__ + '/helpers/*.rb'].each {|file| require file }
# Others

VERSION = File.read('./VERSION').strip

module App
  class Main < Roda
    include BaseHelpers
    include CurrentUser
    raise 'Ruby should be >= 2.3' unless RUBY_VERSION.to_f >= 2.3
    use Rack::Session::Cookie, :secret => ENV.fetch("WORKLOG_SECRET")
    use Rack::Protection, except: :http_origin
    use Rack::Protection::HttpOrigin, origin_whitelist: ["chrome-extension://aicmkgpgakddgnaphhhpliifpcfhicfo", "localhost:3000"]

    # plugin :csrf - Disable CSRF due to API
    plugin :render, engine: "slim"
    plugin :render, engine: "jbuilder", ext: 'json.jbuilder', views: 'views/api', cache: true
    plugin :multi_route
    plugin :json
    plugin :all_verbs
    plugin :environments
    plugin :head # http://mrcook.uk/why-enable-roda-head-plugin
    plugin :default_headers, 'Content-Type'=>'application/json'
    plugin :error_handler do |e|
      response.status = 500
      log_message = "\n#{e.class} (#{e.message}):\n"
      log_message << "  " << e.backtrace.join("\n  ") << "\n\n" if e.backtrace
      puts log_message
      if ENV.fetch('RACK_ENV') == 'development'
        json = { class: e.class, message: e.message, backtrace: e.backtrace.join("\n  ") }
      else
        json = { message: 'Internal Server Error.' }
      end
      json
    end

    if environment == 'development'
      DB.loggers << Logger.new($stdout)
      logger = Logger.new(STDOUT)
      use Rack::CommonLogger, logger
    end

    Sequel::Model.plugin :validation_helpers
    Sequel::Model.plugin :timestamps, create: :created_at, update: :updated_at, update_on_create: true # Default Timestamps

    Dir['./routes/**/*.rb'].each { |f| require f }
    begin
      Dir['./models/**/*.rb'].each { |f| require f } if DB.test_connection
    rescue Exception
      # Nothing
    end

    route do |r|
      r.multi_route do
        halt_request( 404, { error: 'Resource Not Found'} )
      end
      r.root do
        response.status = 200
        {
          name: "UBrand WorkLog Assistant",
          tagline: "Simple Logging for UBrand Team",
          version: VERSION
        }
      end
    end

  end
end