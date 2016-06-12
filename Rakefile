# ./Rakefile

#!/usr/bin/env rake

task :app do
  require './app'
end

Dir[File.dirname(__FILE__) + "/lib/tasks/*.rb"].sort.each do |path|
  require path
end

# Shell

irb = proc do |env|
  ENV['RACK_ENV'] = env
  trap('INT', "IGNORE")
  sh "irb -r ./app"
end

desc "Open irb shell in test mode"
task :irb_test do
  irb.call('test')
end

desc "Open irb shell in development mode"
task :irb_dev do
  irb.call('development')
end

desc "Open irb shell in production mode"
task :irb_prod do
  irb.call('production')
end