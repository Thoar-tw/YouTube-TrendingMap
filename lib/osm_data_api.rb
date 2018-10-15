module APILibrary
  class OSMDataAPI
    module Errors
      class NotFound < StandardError; end
      class Unauthorized < StandardError; end
    end
  
    HTTP_ERROR = {
      401 => Errors::Unauthorized,
      404 => Errors::NotFound
    }.freeze

    def initialize(cache: {})
      @cache = cache
    end

    def osm_api_path(params_str)
      path = 'https://nominatim.openstreetmap.org/search?'
      params_str.each.with_index do |param, index|
        path += '&' unless index.zero?
        path += param
      end
      path
    end
    
    def call_osm_url(url)
      uri = URI.parse(url)
      Net::HTTP.get(uri)
    end
    
    def get_country_data(country_name, output_format)
      param_output_format = 'format=' + output_format
      param_country = 'country=' + country_name
      param_polygon_geojson = 'polygon_geojson=1'
    
      request_url = osm_api_path([param_output_format, param_country, param_polygon_geojson])
      response = call_osm_url(request_url)
      response
    end
    
    def get_boundaries(country_name)
      response = get_country_data(country_name, 'json')
      coordinates = JSON.parse(response)[0]["geojson"]["coordinates"].flatten(2)
      coordinates
    end
  end
end