require 'tempfile'

module Cardigan
  module Templates
    class Retro < Template
      RED    = 'fb4934'
      GREEN  = 'b8bb26'
      YELLOW = 'fabd2f'
      BLUE   = '83a598'

      INVADER = %w[
        ..o.....o..
        ...o...o...
        ..ooooooo..
        .oo.ooo.oo.
        ooooooooooo
        o.ooooooo.o
        o.o.....o.o
        ...oo.oo...
      ]

      def prepare(view)
        super(view)

        view.create_stamp('invader') do
          view.fill_color GREEN

          INVADER.each.with_index do |row, y|
            row.chars.each.with_index do |char, x|
              view.fill_rectangle [(x * 3).pt, (y * -3).pt], 3, 3 if char == 'o'
            end
          end
        end
      end

      def draw_card(issue:, index:, view:)
        super do |top, right, bottom, left|
          draw_header(view, issue)

          view.bounding_box([1.6.in, view.bounds.height - 0.4.in], width: view.bounds.width - 2.in, height: 1.in) do
            view.fill_color *BLACK
            view.font 'PressStart'
            view.text issue.key, size: 24.pt
            view.font 'VT323'
            view.fill_color BLUE
            view.text issue.pleasant_lawyer.tr(' ', '_'), size: 16.pt
            view.fill_color RED
            view.text issue.team.downcase.tr(' ', '_') + '/' + issue.sprint.name.downcase.tr(' ', '_') + '.txt', size: 16.pt
          end

          view.bounding_box([1.6.in, view.bounds.height - 1.4.in], width: view.bounds.width - 2.in, height: view.bounds.height - 1.4.in) do
            view.fill_color *BLACK
            view.text issue.summary, size: 24.pt
          end

          view.stamp_at 'invader', [right - 45.pt, bottom + 36.pt]

          yield top, right, bottom, left if block_given?
        end
      end

      private

      def draw_header(view, issue)
        [RED, GREEN, YELLOW, BLUE].each.with_index(2) do |color, i|
          view.fill_color color
          view.fill_rectangle [(i * 0.2).in, view.bounds.height], 0.2.in, view.bounds.height
        end

        view.fill_color WHITE
        view.fill_rectangle [0.2.in, view.bounds.height - 0.2.in], 1.2.in, 1.2.in
        draw_qr_code(view, issue.url, 0.4.in, view.bounds.height - 0.4.in)
      end

      def draw_qr_code(view, url, x, y)
        file = Tempfile.new(%w[qr .png])
        qrcode = RQRCode::QRCode.new(url)
        png = qrcode.as_png(border_modules: 0)
        file.write(png.to_s)
        file.close
        view.image file.path, at: [x, y], width: 0.8.in
        file.unlink
      end

      def fonts
        super.merge(
          'VT323' => {
            normal: google_font('vt323', 'VT323-Regular')
          },
          'PressStart' => {
            normal: google_font('pressstart2p', 'PressStart2P-Regular')
          }
        )
      end
    end
  end
end
