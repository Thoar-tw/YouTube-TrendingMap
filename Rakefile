# frozen_string_literal: true

require 'rake/testtask'

task :default do
  puts `rake -T`
end

desc 'Run unit and integration tests'
Rake::TestTask.new(:spec) do |t|
  t.pattern = 'spec/*_spec.rb'
  t.warning = false
end

desc 'Run acceptance tests'
Rake::TestTask.new(:spec_accept) do |t|
  puts 'NOTE: run `rake run:test` in another process'
  t.pattern = 'spec/tests_acceptance/hot_videos_page_acceptance.rb'
  # t.pattern = 'spec/tests_acceptance/*_acceptance.rb'
  t.warning = false
end

desc 'Keep rerunning unit/integration tests upon changes'
task :respec do
  sh "rerun -c 'rake spec' --ignore 'coverage/*'"
end

desc 'Keep restarting app server upon changes'
task :rerack do
  sh "rerun -c rackup --ignore 'coverage/*'"
end

namespace :run do
  task :dev do
    sh 'rerun -c "rackup -p 9292"'
  end

  task :test do
    sh 'RACK_ENV=test rackup -p 9000'
  end
end

namespace :db do
  task :config do
    require 'sequel'
    require_relative 'config/environment.rb'
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
    require_relative 'spec/helpers/database_helper.rb'
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
