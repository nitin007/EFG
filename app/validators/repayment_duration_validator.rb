class RepaymentDurationValidator < Validator
  def validate
    rd = RepaymentDuration.new(loan)

    if repayment_duration < rd.min_months
      add_error(:repayment_duration, :too_short, count: rd.min_months)
    elsif repayment_duration > rd.max_months
      add_error(:repayment_duration, :too_long,  count: rd.max_months)
    end
  end

  private
    delegate :loan, :repayment_duration, to: :object
end
