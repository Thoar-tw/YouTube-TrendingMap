# frozen_string_literal: false

require 'roda'
require 'yaml'
require 'json'

module APILibrary
  class App < Roda
    SECRETS = YAML.safe_load(File.read('config/secrets.yml'))
    GOOGLE_CLOUD_KEY = SECRETS['development']['GOOGLE_CLOUD_KEY']
    MAPBOX_TOKEN = SECRETS['development']['MAPBOX_TOKEN']

    # File for Youtube API
    CATEGORIES = YAML.safe_load(File.read('config/category.yml'))

    # Files for Country mapping
    COUNTRIES = YAML.safe_load(File.read('config/country.yml'))
    # COUNTRY_BORDERS_JSON = File.read('config/country_borders.json')
    # COUNTRY_CODE_JSON = File.read('config/country_code.json')
  end
end
