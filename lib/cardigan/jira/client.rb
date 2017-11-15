require_relative './fields'

module Cardigan
  module JIRA
    class Client < SimpleDelegator
      def initialize(options)
        super(::JIRA::Client.new(options))
      end

      def fields
        @fields ||= Fields.new(self)
      end

      def field(name)
        fields[name]
      end
    end
  end
end
