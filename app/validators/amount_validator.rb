class AmountValidator < BaseValidator
  def validate(record)
    amount = record.amount

    if amount.blank?
      add_error(record)
    elsif !amount.between?(minimum, maximum)
      add_error(record)
    end
  end

  private
    def add_error(record)
      super(record, :amount, {
        minimum: minimum.format,
        maximum: maximum.format
      })
    end

    def maximum
      options.fetch(:maximum)
    end

    def minimum
      options.fetch(:minimum)
    end
end
