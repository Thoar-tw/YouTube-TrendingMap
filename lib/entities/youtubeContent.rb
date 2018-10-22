module Entity 
    class YoutubeEntity < Dry::Struct
        include Dry::Types.module

        attribute :kind Types::Strict::String
        attribute :etag Types::Strict::String
        attribute :id Types::Strict::Array do
            attribute :kind,   Types::Strict::String
            attribute :videoId, Types::Strict::String    
          end 
        attribute :snippet Types::Strict::Array do
            attribute :publishedAt,   Types::Strict::String
            attribute :channelId, Types::Strict::String
            attribute :title, Types::Strict::String
            attribute :description, Types::Strict::String
            attribute :thumbnails, Types::Strict::Array do
                attribute :default, Types::Strict::String
                attribute :medium, Types::Strict::String
                attribute :high, Types::Strict::String
            end
            attribute :channelTitle, Types::Strict::String
            attribute :liveBroadcastContent, Types::Strict::String

        end 


    end

end
