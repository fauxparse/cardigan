module Cardigan
  class Page
    attr_reader :issues, :page_number, :template

    def initialize(issues, page:, template:)
      @issues = issues
      @page_number = page
      @template = template
    end

    def first?
      page_number == 1
    end

    def generate(document)
      template.start_page(document)
      issues.each.with_index do |issue, index|
        template.draw_card(view: document, issue: issue, index: index)
      end
    end
  end
end
