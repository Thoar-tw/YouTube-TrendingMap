module APILibrary
  class GooglePlaceAPI
    module Errors
      class NotFound < StandardError; end
      class Unauthorized < StandardError; end
    end
  
    HTTP_ERROR = {
      401 => Errors::Unauthorized,
      404 => Errors::NotFound
    }.freeze

    def initialize(key, cache: {})
      @api_key = key
      @cache = cache
    end

    def country_place_id(name)
      response = get_place(name, 'json')
      response['json'].parse['candidates'][0]['place_id']
    end

    private
    def place_api_path(params_str, output_format)
      path = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/' + output_format + '?'
      params_str.each.with_index do |param, index|
        path += '&' unless index.zero?
        path += param
      end
      path
    end
    
    private
    def get_place(name, output_format)
      param_key = 'key=' + @api_key
      param_input = 'input=' + name
      param_inputtype = 'inputtype=textquery'
      param_field = 'fields=place_id,geometry'
      response = HTTP.get(place_api_path([param_key, param_input, param_inputtype, param_field], output_format))
      response
    end
  end
end