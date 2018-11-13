# frozen_string_literal: true

require 'net/http'
require 'json'

module YouTubeTrendingMap
  # class to get OpenStreetMap data
  class OSMDataAPI
    module Errors
      class EmptyResponse < StandardError; end
    end

    def initialize(cache: {})
      @cache = cache
    end

    def country_data(country_name)
      response = get_country_data(country_name, 'json')
      JSON.parse(response)[0]
      # Country.new(country_data)
    end

    private

    def osm_api_path(params_array)
      path = 'https://nominatim.openstreetmap.org/search?'
      params_array.each.with_index do |param, index|
        path += '&' unless index.zero?
        path += param
      end
      path
    end

    def call_osm_url(url)
      uri = URI.parse(url)
      result = Net::HTTP.get(uri)
      # puts JSON.parse(result)[0]
      successful?(result) ? result : raise_error
    end

    def get_country_data(country_name, output_format)
      param_output_format = 'format=' + output_format
      param_country = 'country=' + country_name
      params_array = [param_output_format, param_country]

      request_url = osm_api_path(params_array)
      response = call_osm_url(request_url)
      response
    end

    def successful?(result)
      JSON.parse(result)[0].nil? ? false : true
    end

    def raise_error
      raise(Errors::EmptyResponse)
    end
  end
end
