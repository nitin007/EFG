module Phase5Rules
  extend self

  LOAN_CATEGORY_REPAYMENT_DURATIONS = {
    nil => 3..120,
    1   => 3..120,
    2   => 3..120,
    3   => 3..120,
    4   => 3..120,
    5   => 3..24,
    6   => 3..36,
    7   => 3..24,
    8   => 3..36
  }

  def claim_limit_calculator
    Phase4ClaimLimitCalculator
  end

  def claim_limit_calculator
    Phase5ClaimLimitCalculator
  end

  def eligibility_check_validations
    [
      EligibilityValidator.new({}),
      AmountValidator.new(minimum: Money.new(1_000_00), maximum: Money.new(1_000_000_00)),
      RepaymentDurationValidator.new({})
    ]
  end

  def loan_category_guarantee_rate
    BigDecimal.new('75.0')
  end

  def loan_category_premium_rate(category_id = nil)
    BigDecimal.new('2.0')
  end

  def loan_category_repayment_duration(type)
    LOAN_CATEGORY_REPAYMENT_DURATIONS.fetch(type)
  end

  def loan_entry_validations
    eligibility_check_validations
  end

  def premium_schedule_required_for_state_aid_calculation?
    true
  end

  def repayment_duration_loan_change_validations
    [
      RepaymentDurationValidator.new({})
    ]
  end

  def state_aid_calculator
    Phase5StateAidCalculator
  end

  def update_loan_lending_limit_validations
    [
      AmountValidator.new(minimum: Money.new(1_000_00), maximum: Money.new(1_000_000_00)),
      RepaymentDurationValidator.new({})
    ]
  end
end
