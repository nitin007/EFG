class Validator
  def self.locale_key
    name.sub(/Validator$/, '').underscore
  end

  def initialize(object, errors)
    @object = object
    @errors = errors
  end

  private
    attr_reader :errors, :object

    def add_error(attribute, message = :invalid, options = {})
      options[:message] = I18n.translate("validators.#{self.class.locale_key}.#{attribute}.#{message}")

      errors.add(attribute, :invalid, options)
    end
end
