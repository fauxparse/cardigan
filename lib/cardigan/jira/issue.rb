module Cardigan
  module JIRA
    class Issue
      def initialize(issue, client:)
        @issue = issue
        @jira = client
      end

      def story_points
        @story_points ||= issue.fields[jira.fields['Story Points'].id]&.to_i
      end

      delegate :key, :summary, to: :issue

      private

      attr_reader :jira, :issue
    end
  end
end

