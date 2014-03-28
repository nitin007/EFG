module PresenterFormatterConcern
  extend ActiveSupport::Concern

  module ClassMethods
    def format(attribute, options)
      formatter = options.fetch(:with)

      define_method(attribute) do
        value = instance_variable_get("@#{attribute}")
        formatter.format(value)
      end

      define_method("#{attribute}=") do |value|
        instance_variable_set "@#{attribute}", formatter.parse(value)
      end
    end
  end
end
