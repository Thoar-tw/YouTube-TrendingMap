# frozen_string_literal: true

require 'base64'
require 'dry/monads/result'
require 'json'

module YouTubeTrendingMap
  module Value
    # List request parser
    class VideoRequest
      include Dry::Monads::Result::Mixin

      def initialize(params)
        @params = params
      end

      # Use in API to parse incoming list requests
      def call
        video = JSON.parse(Base64.urlsafe_decode64(@params['video']))
        Success(video)
      rescue StandardError
        Failure(Value::Result.new(status: :bad_request,
                                  message: 'Video not found'))
      end

      # Use in client App to create params to send
      def self.to_encoded(video)
        Base64.urlsafe_encode64(video.to_json)
      end

      # Use in tests to create a ListRequest object from a list
      def self.to_request(video)
        VideoRequest.new('video' => to_encoded(video))
      end
    end
  end
end
