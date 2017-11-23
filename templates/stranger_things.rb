module Cardigan
  module Templates
    class StrangerThings < Template
      def prepare(view)
        super
        view.font 'Rubik'

        view.create_stamp('warning') do
          warning_icon(view)
        end
      end

      def draw_card(issue:, index:, view:)
        super do |top, right, bottom, left|
          view.svg luchadorable(issue), at: [8.pt, view.bounds.top - 8.pt]

          view.stamp_at 'warning', [left + 16.pt, bottom + 94.pt] unless issue.type == :story
          view.fill_color *BLACK
          view.text_box(
            (issue.story_points || '?').to_s,
            at: [view.bounds.left + 16.pt, view.bounds.bottom + 142.pt],
            width: 48.pt,
            height: 44.pt,
            align: :center,
            valign: :bottom,
            size: 24.pt,
            style: :black
          )

          view.margin(12.pt, 12.pt, 12.pt, 80.pt) do
            view.fill_color color('pink')
            view.text issue.key, size: 36.pt, style: :black

            view.fill_color color('teal')
            # view.text issue.pleasant_lawyer, size: 24.pt, style: :bold
            view.text_box(
              issue.pleasant_lawyer,
              at: [view.bounds.left, view.cursor],
              width: view.bounds.width,
              height: 30,
              size: 24.pt,
              style: :bold,
              overflow: :shrink_to_fit,
              disable_wrap_by_char: true
            )

            view.move_down 34.pt

            view.fill_color *BLACK
            view.text_box(
              issue.summary,
              at: [view.bounds.left, view.cursor],
              width: view.bounds.width,
              height: view.cursor - 12.pt,
              size: 24.pt,
              overflow: :shrink_to_fit,
              disable_wrap_by_char: true
            )

            view.text_box(
              "#{rgb color('grape'), issue.team.upcase + ':'} " +
              "#{rgb color('pink'), issue.sprint.name.upcase}",
              at: [0, 12.pt],
              width: view.bounds.width,
              height: 12.pt,
              valign: :bottom,
              size: 9.pt,
              inline_format: true
            )
          end

          yield top, right, bottom, left if block_given?
        end
      end

      private

      def luchadorable(issue)
        Luchadorable::Avatar.new(issue.id).draw(64)
      end

      def fonts
        super.merge(
          'Rubik' => {
            normal: google_font('rubik', 'Rubik-Light'),
            bold: google_font('rubik', 'Rubik-Bold'),
            black: google_font('rubik', 'Rubik-Black')
          }
        )
      end

      def color(hue)
        Luchadorable::Color.hex(hue, 6).sub(/\A#/, '')
      end

      def draw_story_points(view, issue)
      end

      def warning_icon(view)
        view.fill_color color('yellow')
        view.fill do
          view.move_to 6.679.pt,  3.pt
          view.curve_to [1.48.pt, 12.pt], bounds: [[2.061.pt, 3.pt], [-0.826.pt, 8.pt]]
          view.line_to 18.8.pt,   42.pt
          view.curve_to [29.2.pt, 42.pt], bounds: [[21.113.pt, 46.pt], [26.887.pt, 46.pt]]
          view.line_to 46.52.pt,  12.pt
          view.curve_to [41.32.pt, 3.pt], bounds: [[48.826.pt, 8.pt], [45.939.pt, 3.pt]]
          view.line_to 6.679.pt,  3.pt
        end
      end
    end
  end
end
