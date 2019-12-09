module Sources
  module Api
    module Events
      def self.raise_event(event, payload, headers = nil)
        return if ENV['NO_KAFKA']

        publish_opts = {
          :service => "platform.sources.event-stream",
          :event   => event,
          :payload => payload
        }

        publish_opts[:headers] = headers if headers

        messaging_client.publish_topic(publish_opts)
      end

      private_class_method def self.messaging_client
        require "manageiq-messaging"

        @messaging_client ||= ManageIQ::Messaging::Client.open(
          :protocol => :Kafka,
          :host     => ENV["QUEUE_HOST"] || "localhost",
          :port     => ENV["QUEUE_PORT"] || "9092",
          :encoding => "json"
        )
      end
    end
  end
end
