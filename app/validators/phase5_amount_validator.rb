class Phase5AmountValidator < BaseValidator
  def validate(record)
    amount = record.amount

    if amount.blank?
      add_error(record, :amount, :allowed_amount)
    elsif !amount.between?(Money.new(1_000_00), Money.new(1_000_000_00))
      add_error(record, :amount, :allowed_amount)
    end
  end
end
