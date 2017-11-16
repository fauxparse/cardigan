require_relative './page'
require_relative './template'

module Cardigan
  class Document
    include Prawn::View

    attr_reader :template

    def initialize(issues, template:)
      @issues = issues
      @template = Template[template].new
    end

    def generate(filename)
      template.prepare(self)

      pages.each do |page|
        start_new_page unless page.first?
        page.generate(self)
      end

      save_as filename
    end

    def margin(top, right = top, bottom = top, left = right, &block)
      bounding_box(
        [bounds.left + left, bounds.top - top],
        width: bounds.width - left - right,
        height: bounds.height - top - bottom,
        &block
      )
    end

    def crop_mark(x, y)
      stroke do
        self.line_width = 0.25
        horizontal_line x - 2.5.mm, x + 2.5.mm, at: y
        vertical_line y - 2.5.mm, y + 2.5.mm, at: x
      end
    end

    def crop_marks
      crop_mark bounds.left, bounds.top
      crop_mark bounds.right, bounds.top
      crop_mark bounds.left, bounds.bottom
      crop_mark bounds.right, bounds.bottom
    end

    private

    def document
      @document ||=
        Prawn::Document.new(
          page_size:   template.page_size,
          page_layout: template.page_layout
        )
    end

    def pages
      return enum_for(:pages) unless block_given?

      issues.each_slice(template.issues_per_page).with_index do |issues, page|
        yield Page.new(issues, page: page + 1, template: template)
      end
    end

    attr_reader :issues
  end
end
