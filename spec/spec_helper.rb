# frozen_string_literal: false

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../init.rb'

COUNTRY_NAME = 'Taiwan'.freeze
COUNTRY_CODE = 'tw'.freeze
SECRETS = YAML.safe_load(File.read('config/secrets.yml'))
GOOGLE_CLOUD_KEY = SECRETS['development']['GOOGLE_CLOUD_KEY']
VIDEO_CATEGORIES = YAML.safe_load(File.read('config/category.yml'))

CORRECT_OSM = YAML.safe_load(File.read(__dir__ + '/fixtures/country_results.yml'))
CORRECT_YT = YAML.safe_load(File.read(__dir__ + '/fixtures/popular_list_results.yml'))

CASSETTES_FOLDER = (__dir__ + '/fixtures/cassettes').freeze
CASSETTE_FILE_OSM = 'osm_data_api'.freeze
CASSETTE_FILE_YT = 'youtube_api'.freeze
