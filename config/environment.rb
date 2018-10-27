# frozen_string_literal: false

require 'roda'
require 'yaml'

module APILibrary
  class App < Roda
    SECRETS = YAML.safe_load(File.read('config/secrets.yml'))
    GOOGLE_CLOUD_KEY = SECRETS['development']['GOOGLE_CLOUD_KEY']
    MAPBOX_TOKEN = SECRETS['development']['MAPBOX_TOKEN']

    COUNTRIES = YAML.safe_load(File.read('config/country.yml'))
    CATEGORIES = YAML.safe_load(File.read('config/category.yml'))
  end
end
