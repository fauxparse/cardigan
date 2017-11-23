module Cardigan
  module Templates
    class Flux < Template
      PINK   = [0, 84, 17, 0].freeze
      PURPLE = [77, 97, 0, 0].freeze

      def prepare(document)
        super(document)

        document.create_stamp('flux_logo') do
          flux_logo(document)
        end
      end

      def draw_card(issue:, index:, view:)
        view.font 'Rubik'

        super do |top, right, bottom, left|
          view.margin(12.pt, 24.pt, 12.pt, 72.pt) do
            draw_header(view, issue)
            view.fill_color *BLACK
            view.text issue.summary, size: 18.pt, leading: 3.pt
            draw_footer(view, issue)
            view.stamp_at 'flux_logo', [left + 56.pt, bottom + 13.pt]
          end

          yield top, right, bottom, left if block_given?
        end
      end

      private

      def draw_header(view, issue)
        draw_story_points(view, issue.story_points, -60.pt, view.bounds.top)
        view.fill_color *PINK
        view.text issue.key, size: 12.pt
        view.fill_color *PURPLE
        view.text issue.pleasant_lawyer, size: 18.pt, style: :black
        view.move_down 12.pt
        view.stroke_color *PURPLE
        view.line_width = 2.0
        view.stroke do
          view.horizontal_line 0, 18.pt, at: view.cursor
        end
        view.move_down 12.pt
      end

      def draw_footer(view, issue)
        view.text_box(
          "#{cmyk PURPLE, issue.team.upcase + ':'} " +
          "#{cmyk PINK, issue.sprint.name.upcase}",
          at: [0, view.cursor],
          width: view.bounds.width,
          height: view.cursor,
          valign: :bottom,
          size: 9.pt,
          inline_format: true
        )
      end

      def draw_story_points(view, story_points, x, y)
        view.fill_color *PINK
        view.fill_ellipse [x + 24.pt, y - 24.pt], 24.pt
        view.fill_color *WHITE
        view.text_box(
          story_points&.to_s || '?',
          at: [x, y],
          width: 48.pt,
          height: 44.pt,
          align: :center,
          valign: :center,
          size: 24.pt,
          style: :black,
          leading: 0
        )
      end

      def fonts
        super.merge(
          'Rubik' => {
            normal: google_font('rubik', 'Rubik-Light'),
            bold: google_font('rubik', 'Rubik-Medium'),
            black: google_font('rubik', 'Rubik-Black')
          }
        )
      end

      def flux_logo(view)
        view.fill_color *PURPLE
        view.fill do
          view.move_to 9.25, 7.0
          view.line_to 6.364, 7.0
          view.curve_to [5.658, 6.5], bounds: [[6.038, 7.0], [5.762, 6.792]]
          view.curve_to [4.95, 6.0], bounds: [[5.555, 6.21], [5.276, 6.0]]
          view.line_to 1.75, 6.0
          view.curve_to [1.0, 5.25], bounds: [[1.336, 6.0], [1.0, 5.664]]
          view.line_to 1.0, 4.75
          view.curve_to [1.75, 4.0], bounds: [[1.0, 4.336], [1.336, 4.0]]
          view.line_to 4.282, 4.0
          view.curve_to [4.987, 4.496], bounds: [[4.607, 4.0], [4.883, 4.207]]
          view.curve_to [5.696, 5.0], bounds: [[5.089, 4.79], [5.368, 5.0]]
          view.line_to 9.25, 5.0
          view.curve_to [10.0, 5.75], bounds: [[9.664, 5.0], [10.0, 5.336]]
          view.line_to 10.0, 6.25
          view.curve_to [9.25, 7.0], bounds: [[10.0, 6.664], [9.664, 7.0]]

          view.move_to 9.25, 3.0
          view.line_to 5.03, 3.0
          view.curve_to [4.324, 2.5], bounds: [[4.704, 3.0], [4.428, 2.792]]
          view.curve_to [3.616, 2.0], bounds: [[4.221, 2.21], [3.942, 2.0]]
          view.line_to 0.75, 2.0
          view.curve_to [0.0, 1.25], bounds: [[0.336, 2.0], [0.0, 1.664]]
          view.line_to 0.0, 0.75
          view.curve_to [0.75, 0.0], bounds: [[0.0, 0.336], [0.336, 0.0]]
          view.line_to 2.948, 0.0
          view.curve_to [3.653, 0.496], bounds: [[3.273, 0.0], [3.549, 0.207]]
          view.curve_to [4.362, 1.0], bounds: [[3.755, 0.79], [4.034, 1.0]]
          view.line_to 9.25, 1.0
          view.curve_to [10.0, 1.75], bounds: [[9.664, 1.0], [10.0, 1.336]]
          view.line_to 10.0, 2.25
          view.curve_to [9.25, 3.0], bounds: [[10.0, 2.664], [9.664, 3.0]]
        end
      end
    end
  end
end
