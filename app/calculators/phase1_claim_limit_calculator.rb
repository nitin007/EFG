class Phase1ClaimLimitCalculator < ClaimLimitCalculator

  ClaimLimitPercentage = BigDecimal.new('9.75')

  def phase
    Phase.find(1)
  end

  def total_amount
    cumulative_drawn_amount * ClaimLimitPercentage / 100
  end

end
