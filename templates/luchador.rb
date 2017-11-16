module Cardigan
  module Templates
    class Luchador < Template
      def prepare(view)
        super

        view.font 'Rubik'
      end

      def draw_card(issue:, index:, view:)
        super do |top, right, bottom, left|
          view.margin(12.pt) do
            view.svg luchadorable(issue)

            view.fill_color color('teal')
            view.text_box(
              issue.story_points&.to_s || '?',
              at: [0, view.bounds.top - 64.pt],
              width: 64.pt,
              height: 64.pt,
              align: :center,
              size: 24.pt,
              style: :black,
              leading: 0
            )

            view.margin(0, 0, 0, 76.pt) do
              view.move_down 4
              view.fill_color color('pink')
              view.text issue.key, size: 48.pt, style: :black

              view.margin(64.pt, 0, 0, 0) do
                view.fill_color *BLACK
                view.text issue.summary, size: 24.pt

                view.fill_color color('grape')
                view.text_box issue.sprint.name, size: 16.pt, valign: :bottom
              end
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
          'Rubik' => {
            normal: google_font('rubik', 'Rubik-Light'),
            bold: google_font('rubik', 'Rubik-Medium'),
            black: google_font('rubik', 'Rubik-Black')
          }
        )
      end

      def color(hue)
        Luchadorable::Color.hex(hue, 6).sub(/\A#/, '')
      end
    end
  end
end
