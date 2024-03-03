class BaseProducer
  def self.call(topic, event, **locals)
    hash = JbuilderTemplate.new(ApplicationController) do |json|
      json.partial!(
        partial: "events/#{topic}/#{event}", locals:
      )
    end.attributes!

    hash.merge!(event:)

    Karafka.producer.produce_sync(topic: topic.to_s, payload: hash.to_json)
  end
end
