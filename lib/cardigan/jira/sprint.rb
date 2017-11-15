require_relative './issue'

module Cardigan
  module JIRA
    class Sprint
      include Enumerable

      def initialize(name, client:)
        @name = name
        @client = client
      end

      def issues
        @issues ||=
          client
          .Issue
          .jql("Sprint=#{quote(name)} AND issuetype=Story")
          .map { |issue| Issue.new(issue, client: client) }
      end

      def each
        return enum_for(:each) unless block_given?

        issues.each do |issue|
          yield issue
        end
      end

      private

      attr_reader :name, :client

      def quote(name)
        if name =~ /\A\d+\z/
          name
        else
          "\"#{name}\""
        end
      end
    end
  end
end
