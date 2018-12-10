# frozen_string_literal: true

module YouTubeTrendingMap
  module Forms
    CategoryIdRequest = Dry::Validation.Params do
      CATEGORY_REGEX = /\d/.freeze

      required(:category_id).filled(format?: CATEGORY_REGEX)

      configure do
        config.messages_file = File.join(__dir__, 'errors/form_request.yml')
      end
    end
  end
end
