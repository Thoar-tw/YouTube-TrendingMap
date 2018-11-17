# frozen_string_literal: true

module YouTubeTrendingMap
  module Mixins
    # line credit calculation methods
    module AreaHelper
      def aggregate_lists_from_same_country(area)
        trending_list.select { |video| video.area == area }
      end

      def aggregate_lists_from_same_continent(area)
        trending_list.select { |video| video.area == area ||video.area.continent_determine == area.continent_determine }
      end

      def belonging_continent(country_code)
        CONTINENT_COUNTRY_CODES.each do |continent, countries|
          return continent if countries.key?(country_code)
        end
      end
    end
  end
end
