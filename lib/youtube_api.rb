require 'net/http'
require 'http'
require 'json'
#require_relative '' #parse project data
#require_relative '' #parse contributor data
module APILibrary
    class YoutubeAPI
      module Errors
        class NotFound < StandardError; end
        class Unauthorized < StandardError; end
      end
      HTTP_ERROR = {
      401 => Errors::Unauthorized,
      404 => Errors::NotFound
      }.freeze
        # def initialize(cache: {})
        #     @cache = cache
        # end

        # attach params and keys
        def self.youtube_api_path(path)
            'https://www.googleapis.com/youtube/v3/search?'+path+'&key=AIzaSyAD656N9isRF8t11FeFUvizKJCTB07Vrqo'
        end

        # connect to http server and call api 
        def self.call_yt_url(url)
            # result = @cache.fetch(url) do 
            #     HTTP.headers('Accept' => )
            @uri = URI.parse(url)
            return Net::HTTP.get(@uri)
        end

        # input query and output trending data with json format 
        def self.videos_list_most_popular(part, params)
            @params_str = ''
            # parse query 
            params.each do |param , index|
              if index!=''&&@params_str!=''
                  @params_str = @params_str+ '&' + param.to_s+'='+index.to_s
              elsif params_str==''
                  @params_str = param.to_s+'='+index.to_s
              else
                  break
              end 
            end
          @params_str = 'part='+part+'&'+@params_str
          puts @params_str
          @response = call_yt_url(youtube_api_path(@params_str))
          @result = JSON.parse(@response)
          puts @result
        end

    end
end 





# YoutubeAPI.videos_list_most_popular('snippet',
# {'chart': 'mostPopular',
# 'region_code': 'US',
# 'video_category_id': ''})






