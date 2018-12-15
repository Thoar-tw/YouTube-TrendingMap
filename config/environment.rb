# frozen_string_literal: true

require 'roda'
require 'econfig'
require 'yaml'
require 'json'

module YouTubeTrendingMap
  # Configuration for the App
  class App < Roda
    plugin :environments

    extend Econfig::Shortcut
    Econfig.env = environment.to_s
    Econfig.root = '.'

    use Rack::Session::Cookie, secret: config.SESSION_SECRET

    configure :development, :test do
      require 'pry'

      # Allows running reload! in pry to restart entire app
      def self.reload!
        exec 'pry -r ./init.rb'
      end
    end

    configure :development, :test do
      ENV['DATABASE_URL'] = 'sqlite://' + config.DB_FILENAME
    end

    configure :production do
      # Use deployment platform's DATABASE_URL environment variable
    end

    configure do
      require 'sequel'
      DB = Sequel.connect(ENV['DATABASE_URL'])

      def self.DB # rubocop:disable Naming/MethodName
        DB
      end
    end

    # File for Youtube API
    CATEGORIES = YAML.safe_load(File.read('config/category.yml'))

    # Files for Country mapping
    COUNTRIES = YAML.safe_load(File.read('config/countries.yml'))
    COUNTRY_CODES = YAML.safe_load(
      File.read('config/country_code_iso_alpha2.yml')
    )
    CONTINENTS = YAML.safe_load(File.read('config/continents.yml'))
    CONTINENT_COUNTRY_CODES = JSON.parse(
      File.read('config/continent_country_codes.json')
    )
  end
end
