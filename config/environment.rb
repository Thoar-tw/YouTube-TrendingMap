# frozen_string_literal: false

require 'roda'
require 'yaml'

module APILibrary
  class APP < roda
    CONFIG = YAML.safe_load(File.read('secrets.yml'))
    GOOGLE_CLOUD_KEY = CONFIG['GOOGLE_CLOUD_KEY']
  end
end
