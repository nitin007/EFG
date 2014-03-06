class Phase6AmountValidator < BaseValidator
  FIVE_YEARS = MonthDuration.new(60)
  SIX_HUNDRED_THOUSAND = Money.new(600_000_00)

  def validate(record)
    amount = record.amount
    repayment_duration = record.repayment_duration

    if amount.nil? || repayment_duration.nil?
      return
    end

    if amount > SIX_HUNDRED_THOUSAND && repayment_duration > FIVE_YEARS
      add_error(record, :amount)
    end
  end
end
