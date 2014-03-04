class Validator
  def self.locale_key
    name.sub(/Validator$/, '').underscore
  end

  def initialize(object, options = {})
    @object = object
    @errors = options.fetch(:errors, object.errors)
  end

  private
    attr_reader :errors, :object

    def add_error(attribute, message = :invalid, options = {})
      options[:message] = I18n.translate("validators.#{self.class.locale_key}.#{attribute}.#{message}")

      errors.add(attribute, :invalid, options)
    end
end
