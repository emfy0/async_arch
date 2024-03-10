class BaseTransaction
  include Dry::Transaction(container: AnalyticsApp::CONTAINER)

  class << self
    DRY_RESERVED_INSTANCE_VARIABLES = %i[@steps @operations @stack].freeze

    def within(step_name, **options, &blk)
      transaction = Class.new(self) do
        def self.name = superclass.name
        instance_eval(&blk)
      end

      module_to_be_included = Module.new do
        define_method(:"within_#{step_name}") do |input|
          new_transaction = transaction.new(**operations)

          object_instance_variables = instance_variables - DRY_RESERVED_INSTANCE_VARIABLES

          object_instance_variables.each do |var|
            new_transaction.instance_variable_set(var, instance_variable_get(var))
          end

          result = new_transaction.(input)

          new_transaction_instance_variables = new_transaction.instance_variables - DRY_RESERVED_INSTANCE_VARIABLES

          new_transaction_instance_variables.each do |var|
            instance_variable_set(var, new_transaction.instance_variable_get(var))
          end

          result
        end
      end

      include module_to_be_included
      include WithinAdapters

      step(:"within_#{step_name}", **options)
    end

    def i18n_scope
      namespace = name.split('::').map!(&:underscore).join('.')
      "datacaster.errors.#{namespace}"
    end

    def request_schema(&caster)
      if block_given?
        @request_schema ||= Datacaster.schema(i18n_scope:, &caster)
      else
        @request_schema
      end
    end

    def remap_schema(val = nil)
      @remap_schema ||= val
    end
  end

  def unwrap(params)
    params.to_h.deep_symbolize_keys.except(:controller, :action, :format)
  end

  def typecast(input)
    self.class.request_schema.(input)
      .to_dry_result
      .fmap do |result|
        next result unless self.class.remap_schema

        self.class.remap_schema.each_with_object(result) do |(key, val), current_result|
          current_result[key] = current_result.delete(val)
        end
      end
  end

  # rubocop:disable Style/MissingRespondToMissing
  def method_missing(name, *args, **kwargs, &block)
    step = steps.find { |s| s.name == name }
    super unless step

    operation = operations[step.name]
    unless operation
      raise NotImplementedError,
        "no operation +#{step.operation_name}+ defined for step +#{step.name}+"
    end

    operation.(*args, **kwargs, &block)
  end
  # rubocop:enable Style/MissingRespondToMissing
end
