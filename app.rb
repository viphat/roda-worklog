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
require 'active_support/all'
require 'mail'

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

Mail.defaults do
  delivery_method :smtp, address: ENV.fetch('SMTP_HOST'),
                                       port: ENV.fetch('SMTP_PORT'),
                                       user_name: ENV.fetch('SMTP_USER'),
                                       password: ENV.fetch('SMTP_PASSWORD'),
                                       enable_ssl: true
end

Sequel.extension :seed
SLACK_TOKEN_FOR_VERIFY = ENV.fetch("SLACK_TOKEN_FOR_VERIFY")
SLACK_TOKEN_FOR_POST_LOGS = ENV.fetch("SLACK_TOKEN_FOR_POST_LOGS")

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
    plugin :mailer, :content_type=>'text/html'
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
      if ENV.fetch('RACK_ENV') == 'development'
        puts log_message
        json = { class: e.class, message: e.message, backtrace: e.backtrace.join("\n  ") }
      else
        json = { message: 'Internal Server Error.' }
      end
      json
    end

    if environment == 'production'
      log_file = "./log/#{environment}.log"
      DB.loggers << Logger.new(log_file)
      logger = Logger.new(log_file)
      use Rack::CommonLogger, logger
    else
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

      r.on "mailer" do
        r.is 'preview' do
          response['Content-Type'] = 'text/html'
          @begin_date = (Time.now.beginning_of_day) - 7.days
          @end_date = Time.now.end_of_day
          render('mailer/weekly', engine: "slim", views: 'views')
        end

        r.mail "weekly" do |data|
          @begin_date = (Time.now.beginning_of_day) - 7.days
          @end_date = Time.now.end_of_day
          from 'success@ubrand.cool'
          to 'viphat@ubc.vn'
          subject "Báo cáo hàng tuần từ #{@begin_date.strftime('%d-%m-%Y')} đến ngày #{@end_date.strftime('%d-%m-%Y')}"
          render('mailer/weekly', engine: "slim", views: 'views')
        end

        r.is 'send_mail' do
          App::Main.sendmail("/mailer/weekly", nil)
        end
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