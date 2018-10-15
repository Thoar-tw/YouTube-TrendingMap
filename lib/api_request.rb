# frozen_string_literal: true

require 'http'
require 'yaml'
require 'json'

config = YAML.safe_load(File.read('../config/secrets.yml'))
GOOGLE_MAP_KEY = config['development']['GOOGLE_CLOUD_KEY']

def place_api_path(params_str, output_format)
  path = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/' + output_format + '?'
  params_str.each.with_index do |param, index|
    path += '&' unless index.zero?
    path += param
  end
  path
end

def get_place(name, output_format)
  param_key = 'key=' + GOOGLE_MAP_KEY
  param_input = 'input=' + name
  param_inputtype = 'inputtype=textquery'
  param_field = 'fields=place_id,geometry'
  response = HTTP.get(place_api_path([param_key, param_input, param_inputtype, param_field], output_format))
  response
end

# def get_place_details(placeid)
#   param_key = 'key=' + GOOGLE_MAP_KEY
#   param_id = 'placeid=' + placeid
#   response = HTTP.get('https://maps.googleapis.com/maps/api/place/details/json?' + param_key + '&' + param_id)
#   puts response
# end

# Valid request
place_response = {}
place_response['json'] = get_place('Taiwan', 'json')
place_info = place_response['json'].parse['candidates'][0]

place_results = {}
place_results['place_id'] = place_info['place_id']
place_results['geo_location'] = place_info['geometry']['location']['lat'].to_s + ', ' + place_info['geometry']['location']['lng'].to_s

# Invalid request
place_response['yaml'] = get_place('Taiwan', 'yaml')

File.write('../spec/fixtures/place_response.yml', place_response.to_yaml)
File.write('../spec/fixtures/place_results.yml', place_results.to_yaml)
