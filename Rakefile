# frozen_string_literal: true

desc 'run tests'
task :spec do
  sh 'ruby spec/gateways_spec.rb'
end

desc 'Keep rerunning tests upon changes'
task :respec do
  sh "rerun -c 'rake spec' --ignore 'coverage/*'"
end

desc 'Restart my server upon changes'
task :rerack do
  sh "rerun -c rackup --ignore 'coverage/*'"
end

namespace :db do
  task :config do
    require 'sequel'
    require_relative  'config/environment.rb'
    require_relative  'spec/helpers/database_helper.rb'
    def app
      YouTubeTrendingMap::App
    end
  end

  desc 'Run migrations'
  task migrate: :config do
    Sequel.extension :migration
    puts "Migrating #{app.environment} database to latest"
    Sequel::Migrator.run(app.DB, 'app/infrastructure/database/migrations')
  end

  desc 'Wipe records from all tables'
  task wipe: :config do
    DatabaseHelper.setup_database_cleaner
    DatabaseHelper.wipe_database
  end

  desc 'Delete dev or test database file'
  task drop: :config do
    if app.environment == :production
      puts 'Cannot remove production database'
      return
    end

    FileUtils.rm(YouTubeTrendingMap::App.config.DB_FILENAME)
    puts "Deleted #{YouTubeTrendingMap::App.config.DB_FILENAME}"
  end
end

desc 'Run application console (pry)'
task :console do
  sh 'pry -r ./init.rb'
end

namespace :vcr do
  desc 'delete cassette fixtures'
  task :wipe do
    sh 'rm spec/fixtures/cassettes/*.yml' do |ok, _|
      puts(ok ? 'Cassettes deleted' : 'No cassettes found')
    end
  end
end

namespace :quality do
  CODE = 'app/'

  desc 'run all quality checks'
  task all: %i[rubocop flog reek]

  task :rubocop do
    sh 'rubocop'
  end

  task :flog do
    sh "flog #{CODE}"
  end

  task :reek do
    sh "reek #{CODE}"
  end
end
