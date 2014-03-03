module Phase6Rules
  extend self

  def premium_schedule_required_for_state_aid_calculation?
    false
  end

  def state_aid_calculator
    Phase6StateAidCalculator
  end
end
