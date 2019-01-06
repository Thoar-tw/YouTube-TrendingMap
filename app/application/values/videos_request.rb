# frozen_string_literal: true

require 'base64'
require 'dry/monads/result'
require 'json'

module YouTubeTrendingMap
  module Value
    # List request parser
    class VideosRequest
      include Dry::Monads::Result::Mixin

      def initialize(params)
        @params = params
      end

      # Use in API to parse incoming list requests
      def call
        videos = JSON.parse(Base64.urlsafe_decode64(@params['videos']))
        Success(videos)
      rescue StandardError
        Failure(Value::Result.new(status: :bad_request,
                                  message: 'Video(s) not found'))
      end

      # Use in client App to create params to send
      def self.to_encoded(videos)
        Base64.urlsafe_encode64(videos.to_json)
      end

      # Use in tests to create a ListRequest object from a list
      def self.to_request(videos)
        VideosRequest.new('videos' => to_encoded(videos))
      end
    end
  end
end
