class PercentageValidator < BaseValidator
  
  def validate(record)
    value = record.public_send(attribute)

    unless value && value.between?(minimum, maximum)
      add_error(record)
    end
  end

  private
    
    def add_error(record)
      super(record, attribute, minimum: minimum, maximum: maximum)
    end

    def attribute
      options[:attribute]
    end

    def maximum
      options.fetch(:maximum, 0.0)
    end

    def minimum
      options.fetch(:minimum, 100.0)
    end

end
