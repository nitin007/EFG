class Phase2ClaimLimitCalculator < Phase1ClaimLimitCalculator

  def phase
    Phase.find(2)
  end

end
