class BaseProducer
  class InBatchesContext
    attr_accessor :events, :topic, :event, :version

    def initialize(topic, event, version)
      @events = []
      @topic = topic
      @event = event
      @version = version
    end

    def preapre_event(**locals)
      @events << BaseProducer.generate_event_hash(topic, event, version, locals)
    end
  end

  class << self
    def call(topic, event, version, **locals)
      hash = generate_event_hash(topic, event, version, locals)

      Karafka.producer.produce_sync(topic: topic.to_s, payload: hash.to_json)
    end

    def in_batches(topic, event, version, &block)
      context = InBatchesContext.new(topic, event, version)

      yield context

      messages = context.events.map { |event| { topic: topic.to_s, payload: event.to_json } }

      Karafka.producer.produce_many_sync(messages)
    end

    def generate_event_hash(topic, event, version, locals)
      JbuilderTemplate.new(ApplicationController) do |json|
        json.event event
        json.event_id SecureRandom.uuid
        json.event_time Time.current
        json.event_version version
        json.producer_name 'TaskApp'

        json.data do
          json.partial!(
            partial: "events/#{topic}/#{event}_#{version}", locals:
          )
        end
      end.attributes!
    end
  end
end
