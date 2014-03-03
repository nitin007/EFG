class RepaymentDurationValidator
  def initialize(object)
    @object = object
  end

  def validate
    rd = RepaymentDuration.new(loan)

    if repayment_duration < rd.min_months
      errors.add(:repayment_duration, :too_short, count: rd.min_months)
    elsif repayment_duration > rd.max_months
      errors.add(:repayment_duration, :too_long,  count: rd.max_months)
    end
  end

  private
    attr_reader :object

    delegate :errors, :loan, :repayment_duration, to: :object
end
