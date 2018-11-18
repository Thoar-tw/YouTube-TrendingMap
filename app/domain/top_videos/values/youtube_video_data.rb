# frozen_string_literal: true

module CodePraise
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
