# frozen_string_literal: false

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../lib/osm_data_api.rb'
require_relative '../lib/youtube_api.rb'

USERNAME = 'thoar'.freeze
PROJECT_NAME = 'YoutubeTrendingMap'.freeze
CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
GOOGLE_CLOUD_KEY = CONFIG['development']['GOOGLE_CLOUD_KEY']

COUNTRY_CORRECT = YAML.safe_load(File.read('spec/fixtures/country_results.yml'))
LIST_CORRECT = YAML.safe_load(File.read('spec/fixtures/popular_list_results.yml'))

CASSETTES_FOLDER = 'spec/fixtures/cassettes'.freeze
CASSETTE_FILE = 'youtube_api'.freeze
