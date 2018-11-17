# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.5.1'

# Web application related
gem 'econfig', '~> 2.1'
gem 'rack', '~> 2.0.6'
gem 'puma', '~> 3.12'
gem 'roda', '~> 3.13'
gem 'slim', '~> 4.0'

# Database related
gem 'hirb'
gem 'sequel'

group :development, :test do
  gem 'database_cleaner'
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end

# Networking
gem 'http', '~> 4.0'

# Entity
gem 'dry-struct', '~> 0.5'
gem 'dry-types', '~> 0.13'

# Testing
group :test do
  gem 'minitest', '~> 5.11'
  gem 'minitest-rg', '~> 5.0'
  gem 'rerun', '~> 0.13'
  gem 'simplecov', '~> 0.16'
  gem 'vcr', '~> 4.0'
  gem 'webmock', '~> 3.4'
end

# Quality testing
group :development, :test do
  gem 'flog'
  gem 'reek'
  gem 'rubocop'
end

# Utilities
gem 'rake'

# Debug
gem 'pry', '~> 0.11'
