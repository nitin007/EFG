module Phase6Rules
  extend self

  LOAN_CATEGORY_REPAYMENT_DURATIONS = {
    nil => 3..120,
    1   => 3..120,
    2   => 3..120,
    3   => 3..120,
    4   => 3..120,
    5   => 3..36,
    6   => 3..36
  }

  def loan_category_repayment_duration(type)
    LOAN_CATEGORY_REPAYMENT_DURATIONS.fetch(type)
  end

  def premium_schedule_required_for_state_aid_calculation?
    false
  end

  def state_aid_calculator
    Phase6StateAidCalculator
  end
end
