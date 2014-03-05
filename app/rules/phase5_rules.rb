module Phase5Rules
  extend self

  LOAN_CATEGORY_REPAYMENT_DURATIONS = {
    nil => 3..120,
    1   => 3..120,
    2   => 3..120,
    3   => 3..120,
    4   => 3..120,
    5   => 3..24,
    6   => 3..36
  }

  def eligibility_check_validations
    [
      EligibilityValidator,
      Phase5AmountValidator,
      RepaymentDurationValidator
    ]
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
      RepaymentDurationValidator
    ]
  end

  def state_aid_calculator
    Phase5StateAidCalculator
  end
end
