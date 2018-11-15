# frozen_string_literal: false

require 'roda'
require 'slim'

module YouTubeTrendingMap
  # Web app
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :halt

    route do |routing| # rubocop:disable Metrics/BlockLength
      routing.assets # load CSS

      # GET /
      routing.root do
        trending_list = Mapper::TrendingList.get(region_code, category_id, max_results).all
        if trending_list.none?
          puts 'no trending list!!'
          # flash.now[:notice] = 'Add a Github project to get started'
        end
        view 'home', locals: {
          mapbox_token: App.config.MAPBOX_TOKEN,
          trending_list: trending_list
        }
      end

      routing.on 'trending_map' do
        routing.is do
          # POST /trending_map/
          routing.post do
            # user enter specific region and category
            country_name = routing.params['country_name']
            category_id = routing.params['category_id'].downcase
            region_code = COUNTRY_CODES[country_name]

            # category_id only from 1 to 44
            routing.halt 400 unless (region_code =~ /^[A-Za-z]+$/) && (region_code.length == 2)
            routing.redirect "trending_map/#{region_code}/#{category_id}"
          end

          view 'trending_map', locals: {
            mapbox_token: App.config.MAPBOX_TOKEN,
            countries: COUNTRIES,
            categories: CATEGORIES
          }
        end

        routing.on String, String do |region_code, category_id|
          trending_list = YouTubeTrendingMap::Mapper::TrendingList
                          .new(App.config.GOOGLE_CLOUD_KEY)
                          .get(region_code, category_id, 10)

          routing.post do
            region_code = routing.params['region_code'].downcase
            category_id = routing.params['category_id'].downcase
            # user enter specific region and category (category_id only from 1~44)
            routing.halt 400 unless (region_code =~ /^[A-Za-z]+$/) &&
                                    (category_id =~ [0 - 9] | [0 - 3][0 - 9] | [4][0 - 4])
            routing.redirect "trending_map/#{region_code}/#{category_id}"
          end

          view 'trending_map', locals: {
            trending_list: trending_list,
            mapbox_token: App.config.MAPBOX_TOKEN,
            countries: COUNTRIES,
            categories: CATEGORIES
          }
        end
      end
    end
  end
end
