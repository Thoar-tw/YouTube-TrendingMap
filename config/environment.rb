require 'roda'
require 'yaml'

module APILibrary
  class APP < roda
    CONFIG = YAML.safe_load(File.read('secrets_example.yml'))
    GOOGLE_CLOUD_KEY = CONFIG['GOOGLE_CLOUD_KEY']
  end
end
