# frozen_string_literal: false

require 'roda'
require 'slim'
require 'slim/include'
require 'rails/all'
module YouTubeTrendingMap
  # Web app
  class App < Roda # rubocop:disable Metrics/ClassLength
    plugin :render, engine: 'slim', views: 'app/presentation/views'
    plugin :assets, css: 'style.css', path: 'app/presentation/assets'
    opts[:root] = 'app/presentation/'
    plugin :public, root: 'static'
    # plugin :public, root: 'app/presentation/public'
    plugin :halt
    plugin :flash
    plugin :caching

    use Rack::MethodOverride

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

        result = Services::ListFavoriteVideos.new.call
        if result.failure?
          flash[:error] = result.failure
          view 'home', locals: { favorite_videos: [] }
        end

        favorite_videos = result.value!
        if favorite_videos.none?
          flash.now[:notice] = 'Click on heart icon to add any video into favorite'
        end

        view_favorite_videos = Views::FavoriteVideosList.new(favorite_videos)

        view 'home', locals: {
          favorite_videos: view_favorite_videos
        }
      end

      routing.on 'hot_videos' do # rubocop:disable Metrics/BlockLength
        routing.is do # rubocop:disable Metrics/BlockLength
          # POST /trending_map/
          routing.post do # rubocop:disable Metrics/BlockLength
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
            puts  'Getting hot videos list for ' + request[:region_code] +
                  ' in category ' + request[:category_id]

            hot_videos_list_result = Services::GetHotVideosList.new.call(request)
            if hot_videos_list_result.failure?
              flash[:error] = hot_videos_list_result.failure
              routing.redirect '/hot_videos'
            end

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
        routing.is do
          routing.redirect '/top_videos/global'
        end

        routing.on 'global' do # rubocop:disable Metrics/BlockLength
          routing.post do
            # user enter specific category
            category_id_request = Forms::CategoryIdRequest.call(routing.params)
            if category_id_request.failure?
              error = category_id_request.errors[:category_id][0]
              puts 'category_id_request:' + error
              flash[:error] = error
              routing.redirect '/top_videos/global'
            end

            global_top_videos_list_result =
              Services::GetGlobalTopVideosList.new.call(category_id_request)
            if global_top_videos_list_result.failure?
              failure = global_top_videos_list_result.failure
              puts 'global_top_videos_list_result: ' + failure
              flash[:error] = failure
              routing.redirect '/top_videos/global'
            end

            global_top_videos_list =
              global_top_videos_list_result.value!
            view_global_top_videos_list =
              Views::TopVideosList.new(global_top_videos_list)

            routing.redirect '/top_videos/global'
          end

          view 'global_top_videos', locals: {
            mapbox_token: App.config.MAPBOX_TOKEN,
            global_top_videos_list: view_global_top_videos_list,
            categories: CATEGORIES
          }
        end

        routing.on 'continent' do # rubocop:disable Metrics/BlockLength
          routing.post do # rubocop:disable Metrics/BlockLength
            ### user enter specific region and category
            # downcase the input for continent name
            routing.params['continent_name'] =
              routing.params['continent_name'].downcase
            # Check if continent request matches it's valid string values
            continent_name_request =
              Forms::ContinentNameRequest.call(routing.params)
            if continent_name_request.failure?
              error = continent_name_request.errors[:continent_name][0]
              puts 'continent_name_request: ' + error
              flash[:error] = error
              routing.redirect '/top_videos/continent'
            end

            # Check if category id request matches it's valid regex
            category_id_request = Forms::CategoryIdRequest.call(routing.params)
            if category_id_request.failure?
              error = category_id_request.errors[:category_id][0]
              puts 'category_id_request: ' + error
              flash[:error] = error
              routing.redirect '/top_videos/continent'
            end

            request[:continent_name] = continent_name_request[:continent_name]
            request[:category_id] = category_id_request[:category_id]
            puts  'Getting top videos list for ' + request[:continent_name] +
                  ' in category ' + request[:category_id]

            continent_top_videos_list_result =
              Services::GetContinentTopVideosList.new.call(request)
            if continent_top_videos_list_result.failure?
              failure = continent_top_videos_list_result.failure
              puts 'continent_top_videos_list_result: ' + failure
              flash[:error] = failure
              routing.redirect '/top_videos/continent'
            end

            continent_top_videos_list =
              continent_top_videos_list_result.value!
            view_continent_top_videos_list =
              Views::TopVideosList.new(continent_top_videos_list)

            routing.redirect '/top_videos/continent'
          end

          view 'continent_top_videos', locals: {
            mapbox_token: App.config.MAPBOX_TOKEN,
            continent_top_videos_list: view_continent_top_videos_list,
            continents: CONTINENTS,
            categories: CATEGORIES
          }
        end

        routing.on 'country' do # rubocop:disable Metrics/BlockLength
          routing.post do # rubocop:disable Metrics/BlockLength
            ### user enter specific region and category
            # If user request from country name field, mapping it to region code
            unless routing.params['country_name'].nil?
              region_code = COUNTRY_CODES[routing.params['country_name']]
              routing.params['region_code'] = region_code
            end

            # Check if region code request matches it's valid regex
            region_code_request = Forms::RegionCodeRequest.call(routing.params)
            if region_code_request.failure?
              error = region_code_request.errors[:region_code][0]
              puts 'region_code_request: ' + error
              flash[:error] = region_code_request.errors[:region_code][0]
              routing.redirect '/top_videos/country'
            end

            # Check if category id request matches it's valid regex
            category_id_request = Forms::CategoryIdRequest.call(routing.params)
            if category_id_request.failure?
              error = category_id_request.errors[:category_id][0]
              puts 'category_id_request: ' + error
              flash[:error] = category_id_request.errors[:category_id][0]
              routing.redirect '/top_videos/country'
            end

            request[:region_code] = region_code_request[:region_code]
            request[:category_id] = category_id_request[:category_id]
            country_top_videos_list_result =
              Services::GetCountryTopVideosList.new.call(request)

            if country_top_videos_list_result.failure?
              failure = country_top_videos_list_result.failure
              puts 'country_top_videos_list_result: ' + failure
              flash[:error] = failure
              routing.redirect '/top_videos/country'
            end

            puts  'Getting top videos list for ' + request[:region_code] +
                  ' in category ' + request[:category_id]
            country_top_videos_list = country_top_videos_list_result.value!
            view_country_top_videos_list =
              Views::TopVideosList.new(country_top_videos_list)

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

      routing.on 'add_favorite' do
        routing.post do
          # Add favorite video to database
          result = Services::AddFavoriteVideo.new.call(
            origin_id: routing.params['origin_id'],
            title: routing.params['title'],
            channel_title: routing.params['channel_title'],
            view_count: routing.params['view_count'].to_i,
            embed_link: routing.params['embed_link']
          )
          if result.failure?
            flash[:error] = result.failure
            puts result.failure
            routing.redirect routing.params['url_path']
          end

          routing.redirect routing.params['url_path']
        end
      end

      routing.on 'delete_favorite' do
        routing.post do
          Services::DeleteFavoriteVideo.new.call(
            origin_id: routing.params['origin_id']
          )
          routing.redirect '/'
        end
      end
    end
  end
end
