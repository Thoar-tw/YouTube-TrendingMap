# frozen_string_literal: true

module YouTubeTrendingMap
  module Entity
    # Entity for ranked trending videos in a country
    class CountryRanking < Dry::Struct
      include Mixins::RankingCalculator
      attr_reader :trending_list, :country

      def initialize(trending_list:, country:)
        @trending_list = trending_list
        @country = country
      end

      # don't know if redundant
      def sort_view_counts
        trending_list.sort_by_view_counts
      end
    end
  end
end
