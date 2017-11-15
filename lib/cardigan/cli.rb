require_relative './jira/client'
require_relative './jira/sprint'

module Cardigan
  class CLI
    def run
      sprint.each do |issue|
        puts "(#{issue.story_points || '?'}) #{issue.key} #{issue.summary}"
      end
    end

    private

    def options
      return @options if @options

      @options = Slop.parse do |o|
        o.string '-j', '--jira', 'JIRA instance'
        o.string '-u', '--username', 'JIRA username'
        o.string '-p', '--password', 'JIRA password'
        o.string '-s', '--sprint', 'sprint name or ID'
        o.on '-h', '--help' do
          puts o
          exit
        end
      end
    end

    def sprint
      @sprint ||= Cardigan::JIRA::Sprint.new(sprint_name, client: client)
    end

    def client
      @client ||= Cardigan::JIRA::Client.new(client_options)
    end

    def client_options
      {
        :username     => jira_username,
        :password     => jira_password,
        :site         => jira_url,
        :context_path => '',
        :auth_type    => :basic
      }
    end

    def get_option(name, environment_variable, message)
      options[name] || ENV[environment_variable.to_s] || abort(message)
    end

    def jira_url
      get_option(
        :jira,
        :JIRA_INSTANCE,
        'Please provide a JIRA instance URL with -j or JIRA_INSTANCE'
      )
    end

    def jira_username
      get_option(
        :username,
        :JIRA_USERNAME,
        'Please provide a JIRA username with -u or JIRA_USERNAME'
      )
    end

    def jira_password
      get_option(
        :password,
        :JIRA_PASSWORD,
        'Please provide a JIRA password with -p or JIRA_PASSWORD'
      )
    end

    def sprint_name
      get_option(
        :sprint,
        :JIRA_SPRINT,
        'Please provide a sprint name with -s or JIRA_SPRINT'
      )
    end
  end
end
