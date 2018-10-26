# frozen_string_literal: false

require 'roda'
require 'slim'

module APILibrary
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
            routing.halt 400 unless (region_code =~ /^[A-Za-z]+$/) && (category_id =~ [0-9] | [0-3][0-9] | [4][0-4])
            routing.redirect "trending_map/#{region_code}/#{category_id}"
          end
        end

        routing.on String, String do |region_code, category_id|
          # popular_list = APILibrary::PopularListMapper
          #   .new(GOOGLE_CLOUD_KEY)
          #   .query(region_code, category_id)
          popular_list = "temp"

          view 'trending_map', locals: { popular_list: popular_list, mapbox_token: MAPBOX_TOKEN }
        end
      end
    end
  end
end
