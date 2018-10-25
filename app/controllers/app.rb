require 'roda'
require 'slim'

module APILibrary
  #web app 
  class App < Roda
    plugin :render,engine: 'slim',views:'app/views'
    plugin :assets, css:'style.css',path: 'app/views/assets'
    plugin :halt
    
    route do |routing|
      routing.assets #load css

      #GET / 
      routing.root do 
        view 'home'
      end

      routing.on 'project' do 
        routing.is do 
          #POST /project/
          routing.post do 
            region = routing.params['region'].downcase
            categoryid = routing.params['categoryid'].downcase
            # user enter specific region and category 
            # categoryid only from 1~44  
            if (/^[A-Za-z]+$/ =~ region && [0-9]|[0-3][0-9]|[4][0-4]=~categoryid)then
              routing.redirect "ytTrendMap/#{region}/#{category}"
            else
              routing.halt.400
            end 
          end
        end

        routing.on String,String do |region,category|
          youtubeTrendingMap = APILibrary::PopularListMapper
            .new(GOOGLE_CLOUD_KEY)
            .query(place,categoryid)
          
          view 'project',locals : {project: youtubeTrendingMap} 
        end
      end


