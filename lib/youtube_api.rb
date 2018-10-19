module APILibrary2
    class YoutubeAPI
        def initialize(key, cache: {})
            @api_key = key
            @cache = cache
        end
        def youtube_api_path(params_str)
            path = 'https://www.googleapis.com/youtube/v3/search?'+
            path = path+'key='+ @api_key
        end
        def self.videos_list_most_popular(part, params)
              params_str = ''
              params.each do |param , index|
                if index!=''&&params_str!=''
                    params_str = params_str+ '&' + param.to_s+'='+index.to_s
                elsif params_str==''
                    params_str = param.to_s+'='+index.to_s
                else
                    break
                end 
              end
            params_str = 'part='+part+'&'+params_str
            puts params_str
            response = HTTP.get(youtube_api_path(params_str))
            print_results(response)
          end
    end

end 

c = APILibrary2::YoutubeAPI.new
response = c.videos_list_most_popular('snippet,contentDetails,statistics',
{'chart': 'mostPopular',
'region_code': 'US',
'video_category_id': ''})
response