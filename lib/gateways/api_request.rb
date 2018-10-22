# frozen_string_literal: false

require 'http'
require 'net/http'
require 'yaml'
require 'json'

config = YAML.safe_load(File.read('../../config/secrets.yml'))
GOOGLE_CLOUD_KEY = config['development']['GOOGLE_CLOUD_KEY']

# def place_api_path(params_str, output_format)
#   path = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/'
#   path += output_format + '?'
#   params_str.each.with_index do |param, index|
#     path += '&' unless index.zero?
#     path += param
#   end
#   path
# end

# def get_place(name, output_format)
#   param_key = 'key=' + GOOGLE_CLOUD_KEY
#   param_input = 'input=' + name
#   param_inputtype = 'inputtype=textquery'
#   param_field = 'fields=place_id,geometry'
#   param_array = [param_key, param_input, param_inputtype, param_field]
#   response = HTTP.get(place_api_path(param_array, output_format))
#   response
# end

### OSM API Method
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
  Net::HTTP.get(uri)
end

def get_country_data(country_name, output_format)
  param_output_format = 'format=' + output_format
  param_country = 'country=' + country_name
  param_polygon_geojson = 'polygon_geojson=1'
  param_array = [param_output_format, param_country, param_polygon_geojson]
  request_url = osm_api_path(param_array)
  response = call_osm_url(request_url)
  response
end

def get_boundaries(country_name)
  response = get_country_data(country_name, 'json')
  info = JSON.parse(response)
  coordinates = info[0]['geojson']['coordinates'].flatten(2)
  coordinates
end

### Youtube API Method
# attach params and keys
def youtube_api_path(params_array)
  path = 'https://www.googleapis.com/youtube/v3/videos?'
  params_array.each.with_index do |param, index|
    path += '&' unless index.zero?
    path += param
  end
  path
end

# connect to http server and call api
def call_yt_url(url)
  HTTP.get(url)
end

# input query and output trending data with json format
def get_most_popular_videos_list(region_code)
  param_part = 'part=snippet,player,statistics'
  param_chart = 'chart=mostPopular'
  param_region_code = 'regionCode=' + region_code
  param_video_category_id = 'video_category_id=\'\''
  param_key = 'key=' + GOOGLE_CLOUD_KEY

  param_array = [param_part, param_chart, param_region_code, param_video_category_id, param_key]
  response = call_yt_url(youtube_api_path(param_array))
  response
end

## OSM http requests
# Valid request
country_response = {}
country_results = {}

country_response['json'] = get_country_data('Taiwan', 'json')
country_info = JSON.parse(country_response['json'])[0]
country_lon = country_info['lon'].to_s
country_lat = country_info['lat'].to_s
country_coordinates = country_info['geojson']['coordinates'].flatten(2)

country_results['place_id'] = country_info['place_id']
country_results['geo_location'] = country_lon + ', ' + country_lat
country_results['coordinates'] = country_coordinates

# Invalid request
country_response['yaml'] = get_country_data('Taiwan', 'yaml')

## Youtube http requests
# Valid request
popular_list_response = {}
popular_list_results = {}

popular_list_response['TW'] = get_most_popular_videos_list('TW')
popular_list_info = JSON.parse(popular_list_response['TW'])
popular_list_items = popular_list_info['items']
popular_list_length = popular_list_items.length

popular_list_results['items_count'] = popular_list_length

popular_list_items.each.with_index do |item, index|
  i = index + 1
  popular_list_results[i] = {}
  popular_list_results[i]['id'] = item['id']
  popular_list_results[i]['publish_time'] = item['snippet']['publishedAt']
  popular_list_results[i]['title'] = item['snippet']['title']
  popular_list_results[i]['description'] = item['snippet']['description']
  popular_list_results[i]['channel_title'] = item['snippet']['channelTitle']
  popular_list_results[i]['view_count'] = item['statistics']['viewCount']
  popular_list_results[i]['like_count'] = item['statistics']['likeCount']
  popular_list_results[i]['dislike_count'] = item['statistics']['dislikeCount']

  array = item['player']['embedHtml'].split(' ')
  array.each do |attr|
    if attr.start_with?('src=')
      popular_list_results[i]['embed_link'] = 'https:' + attr.split(/"/)[1]
      break
    end
  end
end

# Invalid request
popular_list_response['CT'] = get_most_popular_videos_list('CT')

# ## Google Place http requests
# Valid request
# place_response = {}
# place_response['json'] = get_place('Taiwan', 'json')
# place_info = place_response['json'].parse['candidates'][0]

# place_results = {}
# place_results['place_id'] = place_info['place_id']
# place_results['geo_location'] = place_info['geometry']['location']['lat'].to_s + ', ' + place_info['geometry']['location']['lng'].to_s

# Invalid request
# place_response['yaml'] = get_place('Taiwan', 'yaml')

File.write('../spec/fixtures/country_response.yml', country_response.to_yaml)
File.write('../spec/fixtures/country_results.yml', country_results.to_yaml)
File.write('../spec/fixtures/popular_list_response.yml', popular_list_response.to_yaml)
File.write('../spec/fixtures/popular_list_results.yml', popular_list_results.to_yaml)
