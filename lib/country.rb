# frozen_string_literal: true

module APILibrary
  # Provide access to country data from OSM
  class Country
    def initialize(country_data)
      @country_data = country_data
    end

    def id
      @country_data['place_id']
    end

    def latitude
      @country_data['lat']
    end

    def longitude
      @country_data['lon']
    end

    # return an array of [lon, lat] for boundary points
    def boundaries
      @country_data['geojson']['coordinates'].flatten(2)
    end
  end
end
