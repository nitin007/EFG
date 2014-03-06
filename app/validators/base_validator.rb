class BaseValidator < ActiveModel::Validator
  private
    def add_error(record, attribute, options = {})
      options[:message] = I18n.translate("validators.#{kind}.#{attribute}.invalid")

      record.errors.add(attribute, :invalid, options)
    end
end
