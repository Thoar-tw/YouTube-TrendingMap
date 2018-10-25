# frozen_string_literal: false

module APILibrary
  # Provide access to country data from OSM
  class CountryMapper
    def initialize(gateway_class = OSMDataAPI)
      @gateway_class = gateway_class
      @gateway = @gateway_class.new
    end

    def query(country_name)
      data = @gateway.country_data(country_name)
      build_entity(data)
    end

    def build_entity(data)
      DataMapper.new(data).build_entity
    end

    # Extracts entity specific elements from raw response data structure
    class DataMapper
      def initialize(country_data)
        @country_data = country_data
      end

      def build_entity
        Entity::Country.new(
          place_id: place_id,
          latitude: latitude,
          longitude: longitude,
          boundaries: boundaries
        )
      end

      private

      def place_id
        @country_data['place_id']
      end

      def latitude
        @country_data['lat'].to_f
      end

      def longitude
        @country_data['lon'].to_f
      end

      # return an array of [lon, lat] for boundary points
      def boundaries
        @country_data['geojson']['coordinates'].flatten(2)
      end
    end
  end
end
