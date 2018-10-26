# frozen_string_literal: false

require 'roda'
require 'yaml'

module APILibrary
  class App < Roda
    SECRETS = YAML.safe_load(File.read('config/secrets.yml'))
    GOOGLE_CLOUD_KEY = SECRETS['GOOGLE_CLOUD_KEY']

    VIDEO_CATEGORIES = YAML.safe_load(File.read('config/category.yml'))
  end
end
