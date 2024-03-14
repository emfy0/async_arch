# frozen_string_literal: true

# Application consumer from which all Karafka consumers should inherit
# You can rename it if it would conflict with your current code base (in case you're integrating
# Karafka with other frameworks)
class ApplicationConsumer < Karafka::BaseConsumer
  def validate_event!(event)
    Events
      .const_get(self.class.name.demodulize.gsub('Consumer', ''))
      .const_get("#{event[:event]}#{event[:event_version]}Schema")
      .validate(event)
  end
end
