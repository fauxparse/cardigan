module Cardigan
  module JIRA
    class Fields
      def initialize(client)
        @client = client
      end

      def [](name)
        fields.detect { |field| field.name == name || field.id == name }
      end

      private

      attr_accessor :client

      def fields
        @fields ||= client.Field.all
      end
    end
  end
end

