# frozen_string_literal: false

require 'roda'
require 'yaml'

module APILibrary
  class APP < Roda
    CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
    GOOGLE_CLOUD_KEY = CONFIG['GOOGLE_CLOUD_KEY']
  end
end
