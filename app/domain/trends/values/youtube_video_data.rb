# frozen_string_literal: true

module YouTubeTrendingMap
  module Value
    # Value of a file's full path (delegates to String)
    class YoutubeVideoData < SimpleDelegator
      attr_reader :video_id, :view_counts, :area, :video_creation_time

      def initialize(viewcounts)
        super(viewcounts)
        parse_path
      end

      def ==(other)
        video_id == other.video_id
      end

      alias eql? ==

      def hash
        video_id.hash
      end

      # def parse_path
      #   return if @names

      #   @names = self.match(FILE_PATH_REGEX)
      #   @directory = @names ? @names[:directory] : ''
      #   @filename = @names ? @names[:filename] : self
      # end
      # rubocop:enable Style/RedundantSelf
    end
  end
end

# module YouTubeTrendingMap
#   module Entity
#     # Youtube trending videos in a certain region
#     class RegionalVideo < Dry::Struct
#       include Dry::Types.module

#       attribute :origin_id,       Strict::String
#       attribute :publish_time,    Strict::String.constrained(
#         format: /(\d\d\d\d)-(\d\d)-(\d\d)T(\d\d):(\d\d):(\d\d).000Z/
#       )
#       attribute :title,           Strict::String
#       attribute :description,     Strict::String
#       attribute :channel_title,   Strict::String
#       attribute :view_count,      Strict::Integer
#       attribute :like_count,      Strict::Integer
#       attribute :dislike_count,   Strict::Integer
#       attribute :embed_link,      Strict::String.constrained(
#         format: %r{https\:\/\/www\.youtube\.com\/embed\/(.*?)}
#       )

#       def to_attr_hash
#         to_hash.reject { |key, _| [:id].include? key }
#       end
#     end
#   end
# end
