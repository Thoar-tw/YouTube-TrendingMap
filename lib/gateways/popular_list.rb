# frozen_string_literal: false

require_relative 'youtube_video.rb'

module APILibrary
  # Data structure of popular list queried from Youtube 
  class PopularList
    def initialize(list_data)
      @list_data = list_data
    end

    def count
      @list_data['items'].length
    end

    # Return an array of YoutubeVideo objects
    def videos
      @videos = []
      @list_data['items'].each do |item|
        @videos << YoutubeVideo.new(item)
      end
      @videos
    end
  end
end
