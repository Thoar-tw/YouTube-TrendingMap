require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../lib/github_api.rb'

USERNAME = 'thoar'.freeze
PROJECT_NAME = 'YoutubeTrendingMap'.freeze
CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
GOOGLE_API_TOKEN = CONFIG['token']
CORRECT = YAML.safe_load(File.read('spec/fixtures/results.yml'))

CASSETTES_FOLDER = 'spec/fixtures/cassettes'.freeze
CASSETTE_FILE = 'youtube_api'.freeze
  