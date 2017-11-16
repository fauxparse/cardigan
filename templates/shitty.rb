module Cardigan
  module Templates
    class Shitty < Template
      RED = [0, 100, 100, 0].freeze
      CYAN = [100, 0, 0, 0].freeze
      DARK_RED = [0, 100, 100, 30].freeze
      DARK_GREEN = [50, 0, 70, 30].freeze

      def draw_card(issue:, index:, view:)
        super do |top, right, bottom, left|
          view.margin(7.mm, 5.mm, 0.mm) do
            view.stroke do
              view.stroke_color *RED
              view.line_width 0.5.pt
              view.horizontal_line 0, view.bounds.width, at: view.bounds.top - 10.mm
            end

            view.stroke do
              view.stroke_color *CYAN
              view.line_width 0.25.pt
              view.horizontal_line 0, view.bounds.width, at: view.bounds.top - 4.mm

              y = view.bounds.top - 15.mm
              while y >= 0
                view.horizontal_line 0, view.bounds.width, at: y
                y -= 5.mm
              end
            end

            view.font 'opensans'
            view.fill_color *CYAN
            view.text_box(
              'Code 1037 5 x 3 Ruled System Card',
              at: [0, 3.mm],
              width: view.bounds.width,
              height: 3.mm,
              align: :right,
              size: 6.pt
            )
          end

          view.margin(7.mm, 10.mm, 0) do
            view.font 'marker'
            view.fill_color *BLACK
            view.text issue.key, size: 36.pt
            view.move_down 5.mm
            view.fill_color *DARK_GREEN
            view.text '‘' + issue.pleasant_lawyer + '’', size: 24.pt
            view.move_down 5.mm
            view.fill_color *BLACK
            view.text issue.summary, size: 7.5.mm, leading: 4.5.mm

            if issue.story_points
              view.fill_color *DARK_RED
              view.text_box(
                issue.story_points.to_s,
                at: [view.bounds.right - 10.mm, 15.mm],
                width: 15.mm,
                height: 10.mm,
                size: 10.mm,
                align: :center,
                valign: :center
              )
            end
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
          'opensans' => {
            normal: google_font('opensans', 'OpenSans-Regular', license: 'apache')
          },
          'marker' => {
            normal: google_font('permanentmarker', 'PermanentMarker-Regular', license: 'apache')
          }
        )
      end

      def color(hue)
        Luchadorable::Color.hex(hue, 6).sub(/\A#/, '')
      end
    end
  end
end
