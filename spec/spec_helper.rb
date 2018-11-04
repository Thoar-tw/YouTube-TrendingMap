# frozen_string_literal: false

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'

require 'pry' # for debugging

require_relative '../init.rb'

COUNTRY_NAME = 'Taiwan'.freeze
COUNTRY_CODE = 'tw'.freeze

GOOGLE_CLOUD_KEY = YouTubeTrendingMap::App.config.GOOGLE_CLOUD_KEY
VIDEO_CATEGORIES = YAML.safe_load(File.read('config/category.yml'))

CORRECT_OSM = YAML.safe_load(File.read(__dir__ + '/fixtures/country_results.yml'))
CORRECT_YT = YAML.safe_load(File.read(__dir__ + '/fixtures/popular_list_results.yml'))
