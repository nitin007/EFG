class RepaymentDurationValidator < Validator
  def validate
    if repayment_duration.blank?
      add_error(:repayment_duration, :blank)
      return
    end

    rd = RepaymentDuration.new(loan)

    if repayment_duration.total_months < rd.min_months
      add_error(:repayment_duration, :too_short, count: rd.min_months)
    elsif repayment_duration.total_months > rd.max_months
      add_error(:repayment_duration, :too_long,  count: rd.max_months)
    end
  end

  private
    delegate :loan, :repayment_duration, to: :object
end
