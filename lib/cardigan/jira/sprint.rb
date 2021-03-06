require_relative './issue'
require_relative '../../very_pleasant_lawyer/lawyer'

module Cardigan
  module JIRA
    class Sprint
      include Enumerable

      attr_reader :name

      def initialize(name, client:, issues: [])
        @name = name
        @client = client
        @keys = issues
      end

      def issues
        @issues ||= client.Issue.jql(jql)
          .map { |issue| Issue.new(issue, client: client, sprint: self) }
      end

      def each
        return enum_for(:each) unless block_given?

        issues.each do |issue|
          yield issue
        end
      end

      def pleasant_lawyer(id)
        lawyer.number_to_words(id.to_i)
      end

      private

      attr_reader :client, :keys

      def quote(name)
        if name =~ /\A\d+\z/
          name
        else
          "\"#{name}\""
        end
      end

      def lawyer
        @lawyer ||= VeryPleasantLawyer::Lawyer.new
      end

      def jql
        jql = "Sprint=#{quote(name)} AND issuetype IN (\"Story\", \"Bug\")"
        jql << " AND Key IN (#{keys.map { |k| "\"#{k}\"" }.join(', ')})" if keys.any?
        jql
      end
    end
  end
end
