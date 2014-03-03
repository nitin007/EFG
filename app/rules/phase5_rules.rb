module Phase5Rules
  extend self

  def premium_schedule_required_for_state_aid_calculation?
    true
  end

  def state_aid_calculator
    Phase5StateAidCalculator
  end
end
