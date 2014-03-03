class Validator
  def self.locale_key
    name.sub(/Validator$/, '').underscore
  end

  def initialize(object)
    @object = object
  end

  private
    attr_reader :object

    delegate :errors, to: :object

    def add_error(attribute, message, options = {})
      options[:message] = I18n.translate("validators.#{self.class.locale_key}.#{message}")

      errors.add(attribute, :invalid, options)
    end
end
