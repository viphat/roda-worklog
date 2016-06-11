# ./lib/tasks/database.rb

namespace :db do
  namespace :migrate do
    desc 'Perform migration up to latest migration available'
    task :up => :app do
      Sequel.extension(:migration)
      Sequel::Migrator.run(Sequel::Model.db, "migrate")
      puts "<= db:migrate:up executed"
    end

    desc "Perform migration down (erase all data)"
    task :down => :app do
      Sequel.extension(:migration)
      Sequel::Migrator.run(Sequel::Model.db, "migrate", target: 0)
      puts "<= db:migrate:down executed"
    end
  end

  desc "Perform migration up to latest migration available"
  task :migrate => "db:migrate:up"

  desc "Database seeder"
  task :seed => :app do
    # Drop all in database
    DB.run("
      DO
      $do$
      BEGIN
        IF EXISTS(SELECT relname FROM pg_class where relname = 'schema_seeds') THEN
          DELETE from schema_seeds;
        END IF;
      END
      $do$
    ")
    Sequel::Seed.setup(ENV['RACK_ENV'])
    Sequel::Seeder.apply(DB, "./migrate/seed/")
    puts "<= db:seed seeded"
  end

  desc "Create the database"
  task :create => :app do
    puts "=> Creating database #{ENV.fetch('WORKLOG_DATABASE')}"
    create_db()
    puts "<= db:create executed"
  end

  desc "Drop the database"
  task :drop => :app do
    Sequel::Model.db.disconnect
    config = Sequel::Model.db.opts
    puts "=> Dropping database '#{config[:database]}'"
    drop_db(config)
    puts "<= db:drop executed"
  end

end

def self.create_db()
  environment = {}
  environment["PGUSER"] = ENV.fetch("PG_USER")
  environment["PGPASSWORD"] = ENV.fetch("PG_PASSWORD")
  arguments = []
  arguments << "--encoding=utf-8"
  arguments << "--host=#{ENV.fetch('PG_HOST')}"
  arguments << "--username=#{ENV.fetch('PG_USER')}"
  arguments << ENV.fetch("WORKLOG_DATABASE")
  Process.wait Process.spawn(environment, "createdb", *arguments)
end

def self.drop_db(config)
  environment = {}
  environment["PGUSER"] = config[:user]
  environment["PGPASSWORD"] = config[:password]
  arguments = []
  arguments << "--host=#{config[:host]}" if config[:host]
  arguments << "--username=#{config[:user]}" if config[:user]
  arguments << config[:database]
  Process.wait Process.spawn(environment, "dropdb", *arguments)
end
