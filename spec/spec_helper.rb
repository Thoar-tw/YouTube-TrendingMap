# frozen_string_literal: false

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../lib/gateways/osm_data_api.rb'
require_relative '../lib/gateways/youtube_api.rb'

COUNTRY_NAME = 'Taiwan'.freeze
COUNTRY_CODE = 'tw'.freeze
CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
GOOGLE_CLOUD_KEY = CONFIG['development']['GOOGLE_CLOUD_KEY']

CORRECT_OSM = YAML.safe_load(File.read(__dir__ + '/fixtures/country_results.yml'))
CORRECT_YT = YAML.safe_load(File.read(__dir__ + '/fixtures/popular_list_results.yml'))

CASSETTES_FOLDER = (__dir__ + '/fixtures/cassettes').freeze
CASSETTE_FILE_OSM = 'osm_data_api'.freeze
CASSETTE_FILE_YT = 'youtube_api'.freeze
