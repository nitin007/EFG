class RepaymentDurationValidator < BaseValidator
  def validate(record)
    repayment_duration = record.repayment_duration
    loan = record.loan

    if repayment_duration.blank?
      add_error(record, :repayment_duration, :blank)
      return
    end

    rd = RepaymentDuration.new(loan)

    if repayment_duration.total_months < rd.min_months
      add_error(record, :repayment_duration, :invalid)
    elsif repayment_duration.total_months > rd.max_months
      add_error(record, :repayment_duration, :invalid)
    end
  end
end
