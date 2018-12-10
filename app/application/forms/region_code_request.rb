# frozen_string_literal: true

module YouTubeTrendingMap
  module Forms
    RegionCodeRequest = Dry::Validation.Params do
      REGION_CODE_REGEX = /^[A-Za-z]+$/.freeze

      required(:region_code).filled(format?: REGION_CODE_REGEX)

      configure do
        config.messages_file = File.join(__dir__, 'errors/form_request.yml')
      end
    end
  end
end
