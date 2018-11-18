# frozen_string_literal: true

require_relative 'helpers/spec_helper.rb'
require_relative 'helpers/vcr_helper.rb'
require_relative 'helpers/database_helper.rb'

describe 'Integration Tests of Github API and Database' do
  VcrHelper.setup_vcr
  DatabaseHelper.setup_database_cleaner

  before do
    VcrHelper.configure_vcr_for_youtube
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store project' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to save remote hot videos list data to database' do
      list =  YouTubeTrendingMap::Mapper::HotVideosList
              .new(GOOGLE_CLOUD_KEY)
              .get(COUNTRY_CODE, DEFAULT_CATEGORY, DEFAULT_MAX_RESULTS)

      rebuilt = YouTubeTrendingMap::Repository::For.entity(list).create(list)

      _(rebuilt.count).must_equal(list.count)
      _(rebuilt.belonging_country).must_equal(list.belonging_country)

      list.videos.each do |video|
        found = rebuilt.videos.find do |potential|
          potential.origin_id == video.origin_id
        end

        _(found.publish_time).must_equal video.publish_time
        _(found.title).must_equal video.title
        _(found.description).must_equal video.description
        _(found.channel_title).must_equal video.channel_title
        _(found.embed_link).must_equal video.embed_link
      end
    end
  end
end
