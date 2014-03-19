class Phase4ClaimLimitCalculator < ClaimLimitCalculator

  ClaimLimitPercentage = BigDecimal.new('15')

  def phase
    Phase.find(4)
  end

  def total_amount
    cumulative_drawn_amount * ClaimLimitPercentage / 100
  end

end
