class Phase3ClaimLimitCalculator < ClaimLimitCalculator

  FirstMillionPercentage = BigDecimal.new('15')
  AboveFirstMillionPercentage = BigDecimal.new('9.225')

  def phase
    Phase.find(3)
  end

  def total_amount
    first_million_amount + above_first_million_amount
  end

  private

  def first_million_amount
    amount = cumulative_drawn_amount >= Money.new(1_000_000_00) ? Money.new(1_000_000_00) : cumulative_drawn_amount
    amount * FirstMillionPercentage / 100
  end

  def above_first_million_amount
    if cumulative_drawn_amount > Money.new(1_000_000_00)
      (cumulative_drawn_amount - Money.new(1_000_000_00)) * AboveFirstMillionPercentage / 100
    else
      Money.new(0)
    end
  end

end
