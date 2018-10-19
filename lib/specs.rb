require 'minitest/autorun'
require_relative  'osm_data_api'
require 'net/http'
describe "PlaceTest" do 
    @osplace = OSMDataAPI.new
end

it "return if osm_api_path is working url "do 
    url = URI.parse(url_str)
    Net::HTTP.start(url.host, url.port) do |http|
    http.head(url.request_uri).code == '200'
    end 
end

it "return if country data in all countries" do 
    @osplace.osm_api_path 
end

it "return if connection success"do 
end 


