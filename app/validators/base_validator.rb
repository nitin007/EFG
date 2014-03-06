class BaseValidator < ActiveModel::Validator
  private
    def add_error(record, attribute, message = :invalid, options = {})
      options[:message] = I18n.translate("validators.#{kind}.#{attribute}.#{message}")

      record.errors.add(attribute, :invalid, options)
    end
end
