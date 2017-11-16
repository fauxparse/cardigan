require 'prawn/measurement_extensions'

module Cardigan
  class Template
    BLACK  = [0, 0, 0, 100].freeze
    WHITE  = [0, 0, 0, 0].freeze

    def self.[](name)
      @templates ||= {}
      @templates[name] ||=
        begin
          require_relative "../../templates/#{name}"
          Inflecto.constantize(Inflecto.camelize('cardigan/templates/' + name))
        rescue LoadError, NameError
          abort("Couldn’t find a template named #{name}")
        end
    end

    def page_size
      'A4'
    end

    def page_layout
      :landscape
    end

    def issues_per_page
      rows * columns
    end

    def columns
      2
    end

    def rows
      2
    end

    def card_width
      5.in
    end

    def card_height
      3.in
    end

    def width
      card_width * columns
    end

    def height
      card_height * rows
    end

    def prepare(document)
      document.font_families.update(fonts)
    end

    def start_page(document)
      draw_crop_marks(document)
    end

    def draw_card(issue:, index:, view:)
      row = index / columns
      column = index % columns

      with_bounding_box(view, column, row) do |top, right, bottom, left|
        yield top, right, bottom, left if block_given?
      end
    end

    private

    def draw_crop_marks(view)
      rows.times do |row|
        columns.times do |column|
          with_bounding_box(view, column, row) do
            view.crop_marks
          end
        end
      end
    end

    def origin(view, column, row)
      cx = (view.bounds.left + view.bounds.right) / 2
      cy = (view.bounds.top + view.bounds.bottom) / 2

      x = cx - (width / 2) + card_width * column
      y = cy + (height / 2) - card_height * row
      [x, y]
    end

    def with_bounding_box(view, column, row, &block)
      left, top = origin(view, column, row)
      view.bounding_box([left, top], width: card_width, height: card_height) do
        yield top, left + card_width, top - card_height, left
      end
    end

    def fonts
      {}
    end

    def font_filename(name)
      "#{File.dirname(__FILE__)}/../../fonts/#{name}.ttf"
    end

    def cmyk(color, text)
      c, m, y, k = color
      "<color c='#{c}' m='#{m}' y='#{y}' k='#{k}'>#{text}</color>"
    end
  end
end
