require_relative './issue'
require_relative '../../very_pleasant_lawyer/lawyer'

module Cardigan
  module JIRA
    class Sprint
      include Enumerable

      attr_reader :name

      def initialize(name, client:)
        @name = name
        @client = client
      end

      def issues
        @issues ||=
          client
          .Issue
          .jql("Sprint=#{quote(name)} AND issuetype=Story")
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

      attr_reader :client

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
    end
  end
end
