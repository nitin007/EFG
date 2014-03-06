class Phase6AmountValidator < BaseValidator
  FIVE_YEARS = 60
  ONE_THOUSAND = Money.new(1_000_00)
  ONE_POINT_TWO_MILLION = Money.new(1_200_000_00)
  SIX_HUNDRED_THOUSAND = Money.new(600_000_00)

  def validate(record)
    amount = record.amount
    repayment_duration = record.repayment_duration

    if amount.blank?
      add_error(record, :amount, :allowed_amount)
    elsif !amount.between?(ONE_THOUSAND, ONE_POINT_TWO_MILLION)
      add_error(record, :amount, :allowed_amount)
    elsif amount > SIX_HUNDRED_THOUSAND && repayment_duration.total_months > FIVE_YEARS
      add_error(record, :amount, :maximum_five_year_amount)
    end
  end
end
