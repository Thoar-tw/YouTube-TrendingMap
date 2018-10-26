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
            routing.halt 400 unless (/^[A-Za-z]+$/ =~ region_code) && ([0-9]|[0-3][0-9]|[4][0-4] =~ category_id)
            routing.redirect "trending_map/#{region_code}/#{category_id}"
          end
        end

        routing.on String, String do |region_code, category_id|
          trending_map = APILibrary::PopularListMapper
            .new(GOOGLE_CLOUD_KEY)
            .query(region_code, category_id)

          view 'trending_map', locals: { trending_map: trending_map }
        end
      end
    end
  end
end
