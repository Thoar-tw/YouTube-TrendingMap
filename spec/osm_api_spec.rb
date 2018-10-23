# frozen_string_literal: false

require_relative 'spec_helper.rb'

describe 'Tests OSM API library' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock
  end

  before do
    VCR.insert_cassette CASSETTE_FILE_OSM, record: :new_episodes, match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  # @osplace = OSMDataAPI.new
  describe 'OSM country data' do
    it 'HAPPY: should provide a set of lat, lon of the country boundaries' do
      country = APILibrary::OSMDataAPI.new.country(COUNTRY_NAME)
      geo_location = country.longitude.to_s + ', ' + country.latitude.to_s
      _(country.place_id).must_equal CORRECT_OSM['place_id']
      _(geo_location).must_equal CORRECT_OSM['geo_location']
      _(country.boundaries).must_equal CORRECT_OSM['coordinates']
    end

    it 'BAD: should raise exception while the query is empty' do
      proc do
        APILibrary::OSMDataAPI.new.country('')
      end.must_raise APILibrary::OSMDataAPI::Errors::EmptyResponse
    end
  end
end
