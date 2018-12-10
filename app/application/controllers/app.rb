# frozen_string_literal: false

require 'roda'
require 'slim'
require 'slim/include'

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
    view_global_top_videos_list = nil
    view_continent_top_videos_list = nil
    view_country_top_videos_list = nil

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
          routing.post do
            # If user request from country name field, mapping it to region code
            unless routing.params['country_name'].nil?
              region_code = COUNTRY_CODES[routing.params['country_name']]
              routing.params['region_code'] = region_code
            end

            # Check if region code request matches it's valid regex
            region_code_request = Forms::RegionCodeRequest.call(routing.params)
            if region_code_request.failure?
              flash[:error] = region_code_request.errors[:region_code][0]
              routing.redirect '/hot_videos'
            end

            # Check if category id request matches it's valid regex
            category_id_request = Forms::CategoryIdRequest.call(routing.params)
            if category_id_request.failure?
              flash[:error] = category_id_request.errors[:category_id][0]
              routing.redirect '/hot_videos'
            end

            request[:region_code] = region_code_request[:region_code]
            request[:category_id] = category_id_request[:category_id]
            hot_videos_list_result = Services::GetHotVideosList.new.call(request)

            if hot_videos_list_result.failure?
              flash[:error] = hot_videos_list_result.failure
              routing.redirect '/hot_videos'
            end

            puts 'Getting hot videos list for ' + request[:region_code] + ' in category ' + request[:category_id]
            hot_videos_list = hot_videos_list_result.value!
            view_hot_videos_list = Views::HotVideosList.new(hot_videos_list)

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
          routing.redirect '/top_videos/global'
        end

        routing.on 'global' do
          routing.post do
            # user enter specific region and category
            category_id = routing.params['category_id'].nil? ? DEFAULT_CATEGORY : routing.params['category_id']

            begin
              global_top_videos_list =  YouTubeTrendingMap::Mapper::GlobalTopVideosList
                                        .new(App.config.GOOGLE_CLOUD_KEY)
                                        .get(category_id, 10)

              if global_top_videos_list.nil?
                flash[:error] = 'global top videos list is nil'
                routing.redirect '/top_videos'
              end

              view_global_top_videos_list = Views::TopVideosList.new(global_top_videos_list)
            rescue StandardError => error
              puts error
              flash[:error] = 'Having trouble getting global top videos list'
              routing.redirect '/top_videos/global'
            end

            routing.redirect '/top_videos/global'
          end

          view 'global_top_videos', locals: {
            mapbox_token: App.config.MAPBOX_TOKEN,
            global_top_videos_list: view_global_top_videos_list,
            categories: CATEGORIES
          }
        end

        routing.on 'continent' do # rubocop:disable Metrics/BlockLength
          routing.post do
            # user enter specific region and category
            continent = routing.params['continent'].downcase
            category_id = routing.params['category_id'].nil? ? DEFAULT_CATEGORY : routing.params['category_id']

            begin
              continent_top_videos_list =
                YouTubeTrendingMap::Mapper::ContinentTopVideosList
                .new(App.config.GOOGLE_CLOUD_KEY)
                .get(continent, category_id, 10)
              
              puts '~~~'
              if continent_top_videos_list.nil?
                puts 'continent_top_videos_list.nil'
                flash[:error] = 'continent top videos list is nil'
                routing.redirect '/top_videos/continent'
              end

              view_continent_top_videos_list = Views::TopVideosList.new(continent_top_videos_list)
            rescue StandardError => error
              puts error
              flash[:error] = 'Having trouble getting continent top videos list'
              routing.redirect '/top_videos/continent'
            end

            routing.redirect '/top_videos/continent'
          end

          view 'continent_top_videos', locals: {
            mapbox_token: App.config.MAPBOX_TOKEN,
            continent_top_videos_list: view_continent_top_videos_list,
            countries: COUNTRIES,
            categories: CATEGORIES
          }
        end

        routing.on 'country' do
          routing.post do # rubocop:disable Metrics/BlockLength
            # user enter specific region and category
            
            view_country_top_videos_list = nil

            routing.redirect '/top_videos/country'
          end

          view 'country_top_videos', locals: {
            mapbox_token: App.config.MAPBOX_TOKEN,
            country_top_videos_list: view_country_top_videos_list,
            countries: COUNTRIES,
            categories: CATEGORIES
          }
        end
      end
    end
  end
end
