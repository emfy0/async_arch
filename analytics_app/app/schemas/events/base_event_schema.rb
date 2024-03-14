module Events
  class BaseEventSchema
    class << self
      METADATA =
        Datacaster.partial_schema do
          hash_schema(
            event: string,
            event_id: string,
            event_time: iso8601,
            event_version: integer,
            producer_name: string
          )
        end

      def event_schema(&caster)
        if block_given?
          @event_schema ||= Datacaster.partial_schema(&caster)
        else
          @event_schema
        end
      end

      def validate(data)
        (METADATA & event_schema).(data).to_dry_result
      end
    end
  end
end
