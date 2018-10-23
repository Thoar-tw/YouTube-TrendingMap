# frozen_string_literal: false

require 'net/http'
require 'json'
require_relative 'country.rb'

module APILibrary
  # class to get OpenStreetMap data
  class OSMDataAPI
    module Errors
      class EmptyResponse < StandardError; end
    end

    def initialize(cache: {})
      @cache = cache
    end

    def country(country_name)
      response = get_country_data(country_name, 'json')
      country_data = JSON.parse(response)[0]
      Country.new(country_data)
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
      param_polygon_geojson = 'polygon_geojson=1'
      params_array = [param_output_format, param_country, param_polygon_geojson]

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