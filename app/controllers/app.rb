# frozen_string_literal: false

require 'roda'
require 'slim'

module YouTubeTrendingMap
  # Web app
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :halt

    route do |routing|
      routing.assets # load CSS

      # GET /
      routing.root do
        view 'home'
      end

      routing.on 'trending_map' do
        routing.is do
          # POST /trending_map/
          routing.post do
            region_code = routing.params['region_code'].downcase
            category_id = routing.params['category_id'].downcase
            # user enter specific region and category (category_id only from 1~44)
            routing.halt 400 unless (region_code =~ /^[A-Za-z]+$/) &&
                                    (region_code.length == 2) &&
                                    (category_id =~ [0 - 9] | [0 - 3][0 - 9] | [4][0 - 4])
            routing.redirect "trending_map/#{region_code}/#{category_id}"
          end

          view 'trending_map', locals: {
            mapbox_token: App.config.MAPBOX_TOKEN,
            countries: COUNTRIES,
            categories: CATEGORIES
          }
        end

        routing.on String, String do |region_code, category_id|
          trending_list =  YouTubeTrendingMap::TrendingListMapper
                          .new(App.config.GOOGLE_CLOUD_KEY)
                          .query(region_code, category_id)

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
