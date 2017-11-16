require_relative './stranger_things'

module Cardigan
  module Templates
    class StrangerThings1up < StrangerThings
      def rows
        1
      end

      def columns
        1
      end

      def page_size
        [3.in, 5.in]
      end

      private

      def draw_crop_marks(_); end
    end
  end
end
