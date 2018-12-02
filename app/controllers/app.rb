# frozen_string_literal: false

require 'roda'
require 'slim'

module YouTubeTrendingMap
  # Web app
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/presentation/views'
    plugin :assets, css: 'style.css', path: 'app/presentation/assets'
    plugin :halt
    plugin :flash

    DEFAULT_CATEGORY = 0
    DEFAULT_MAX_RESULTS = 10

    hot_videos_list = nil
    view_hot_videos_list = nil

    route do |routing| # rubocop:disable Metrics/BlockLength
      routing.assets # load CSS

      # GET /
      routing.root do
        # Get viewer's previously seen lists from session
        session[:watching] ||= []

        global_top_videos_list =  Mapper::GlobalTopVideosList
                                  .new(App.config.GOOGLE_CLOUD_KEY)
                                  .get(DEFAULT_CATEGORY, DEFAULT_MAX_RESULTS)

        if global_top_videos_list.nil?
          flash[:error] = 'global top videos list is nil'
          routing.redirect '/'
        end

        view 'home', locals: {
          mapbox_token: App.config.MAPBOX_TOKEN,
          global_top_videos_list: global_top_videos_list
        }
      end

      routing.on 'hot_videos' do # rubocop:disable Metrics/BlockLength
        routing.is do # rubocop:disable Metrics/BlockLength
          # POST /trending_map/
          routing.post do # rubocop:disable Metrics/BlockLength
            # user enter specific region and category
            region_code =
              if routing.params['country_name'].nil?
                routing.params['region_code']
              else
                COUNTRY_CODES[routing.params['country_name']]
              end

            category_id = routing.params['category_id']

            # region_code: e.g., US, TW; category_id: 1 - 44
            unless  (region_code =~ /^[A-Za-z]+$/) &&
                    (region_code.length == 2) &&
                    (category_id =~ /\d/)
              response.status = 400
              routing.redirect '/hot_videos'
            end

            begin
              hot_videos_list = YouTubeTrendingMap::Mapper::HotVideosList
                                .new(App.config.GOOGLE_CLOUD_KEY)
                                .get(region_code, category_id, 10)

              if hot_videos_list.nil?
                flash[:error] = 'hot videos list is nil'
                routing.redirect '/hot_videos'
              end

              view_hot_videos_list = Views::HotVideosList.new(hot_videos_list)
            rescue StandardError
              flash[:error] = 'Having trouble getting hot videos list'
              routing.redirect '/hot_videos'
            end

            routing.redirect '/hot_videos'
          end

          view 'hot_videos', locals: {
            mapbox_token: App.config.MAPBOX_TOKEN,
            hot_videos_list: view_hot_videos_list,
            countries: COUNTRIES,
            categories: CATEGORIES
          }
        end
      end

      routing.on 'top_videos' do # rubocop:disable Metrics/BlockLength
        routing.is do # rubocop:disable Metrics/BlockLength
          # POST /trending_map/
          routing.post do # rubocop:disable Metrics/BlockLength
            # user enter specific region and category

            routing.redirect '/top_videos'
          end

          view 'top_videos', locals: {
            mapbox_token: App.config.MAPBOX_TOKEN,
            # global_top_videos_list: global_top_videos_list,
            countries: COUNTRIES,
            categories: CATEGORIES
          }
        end

        routing.on 'global' do

          view 'top_videos', locals: {
            mapbox_token: App.config.MAPBOX_TOKEN,
            # global_top_videos_list: global_top_videos_list,
            countries: COUNTRIES,
            categories: CATEGORIES
          }
        end

        routing.on 'continent' do

          view 'top_videos', locals: {
            mapbox_token: App.config.MAPBOX_TOKEN,
            # global_top_videos_list: global_top_videos_list,
            countries: COUNTRIES,
            categories: CATEGORIES
          }
        end

        routing.on 'country' do

          view 'top_videos', locals: {
            mapbox_token: App.config.MAPBOX_TOKEN,
            # global_top_videos_list: global_top_videos_list,
            countries: COUNTRIES,
            categories: CATEGORIES
          }
        end
      end
    end
  end
end
