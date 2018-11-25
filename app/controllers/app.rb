# frozen_string_literal: false

require 'roda'
require 'slim'

module YouTubeTrendingMap
  # Web app
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :halt
    plugin :flash

    hot_videos_list = nil
    view_hot_videos_list = nil

    route do |routing| # rubocop:disable Metrics/BlockLength
      routing.assets # load CSS

      # GET /
      routing.root do
        # Get viewer's previously seen lists from session
        session[:watching] ||= []

        global_top_videos = Mapper::GlobalTopVideos.get(region_code, category_id, max_results).all
        if global_top_videos.none?
          puts 'no trending list!!'
          flash.now[:notice] = 'Add a Github project to get started'
        end
        view 'home', locals: {
          mapbox_token: App.config.MAPBOX_TOKEN,
          hot_videos_list: hot_videos_list
        }
      end

      routing.on 'trending_map' do # rubocop:disable Metrics/BlockLength
        routing.is do # rubocop:disable Metrics/BlockLength
          # POST /trending_map/
          routing.post do
            # user enter specific region and category
            if routing.params['country_name'].nil?
              region_code = routing.params['region_code']
            else
              country_name = routing.params['country_name']
              region_code = COUNTRY_CODES[country_name]
            end

            category_id = routing.params['category_id']

            begin
              hot_videos_list = YouTubeTrendingMap::Mapper::HotVideosList
                                .new(App.config.GOOGLE_CLOUD_KEY)
                                .get(region_code, category_id, 10)

              if hot_videos_list.nil?
                flash[:error] = 'hot videos list is nil'
                routing.redirect '/trending_map'
              end

              view_hot_videos_list = Views::HotVideosList.new(hot_videos_list)

            rescue StandardError
              flash[:error] = 'Having trouble getting hot videos list'
              routing.redirect '/trending_map'
            end

            # category_id only from 1 to 44
            routing.halt 400 unless (region_code =~ /^[A-Za-z]+$/) && (region_code.length == 2)
            routing.redirect '/trending_map'
          end

          view 'trending_map', locals: {
            mapbox_token: App.config.MAPBOX_TOKEN,
            hot_videos_list: view_hot_videos_list,
            countries: COUNTRIES,
            categories: CATEGORIES
          }
        end

        # routing.on String, Integer do |path_region_code, path_category_id|
        #   puts 'routing on...' + path_region_code + '/' + path_category_id.to_s
        #   trending_list = YouTubeTrendingMap::Mapper::HotVideosList
        #                   .new(App.config.GOOGLE_CLOUD_KEY)
        #                   .get(path_region_code, path_category_id, 10)

        #   routing.post do
        #     if routing.params['country_name'].nil?
        #       region_code = routing.params['region_code']
        #     else
        #       country_name = routing.params['country_name']
        #       region_code = COUNTRY_CODES[country_name]
        #     end
        #     category_id = routing.params['category_id']
        #     puts 'in routing post...'

        #     # user enter specific region and category (category_id only from 1~44)
        #     routing.halt 400 unless (region_code =~ /^[A-Za-z]+$/) && (region_code.length == 2)
        #     puts "/trending_map/#{region_code}/#{category_id}"
        #     routing.redirect "/trending_map/#{region_code}/#{category_id}"
        #   end

        #   view 'trending_map', locals: {
        #     trending_list: trending_list,
        #     mapbox_token: App.config.MAPBOX_TOKEN,
        #     countries: COUNTRIES,
        #     categories: CATEGORIES
        #   }
        # end
      end
    end
  end
end
