class Phase5ClaimLimitCalculator < Phase4ClaimLimitCalculator

  def phase
    Phase.find(5)
  end

end
