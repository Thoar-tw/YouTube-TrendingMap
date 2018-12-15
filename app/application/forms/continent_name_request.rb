# frozen_string_literal: true

module YouTubeTrendingMap
  module Forms
    ContinentNameRequest = Dry::Validation.Params do
      required(:continent_name).value(
        included_in?: [
          'asia', 'africa', 'north america',
          'south america', 'europe', 'oceania'
        ]
      )

      configure do
        config.messages_file = File.join(__dir__, 'errors/form_request.yml')
      end
    end
  end
end
