module Cardigan
  module JIRA
    class Issue
      attr_reader :sprint

      def initialize(issue, client:, sprint:)
        @issue = issue
        @jira = client
        @sprint = sprint
      end

      def story_points
        @story_points ||= issue.fields[jira.fields['Story Points'].id]&.to_i
      end

      def pleasant_lawyer
        sprint.pleasant_lawyer(issue.id)
      end

      def team
        issue.fields[jira.fields['Team'].id]['value']
      end

      delegate :key, :summary, to: :issue

      private

      attr_reader :jira, :issue
    end
  end
end

