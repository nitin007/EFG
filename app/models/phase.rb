class Phase < StaticAssociation
  self.data = [
    { id: 1, euro_conversion_rate: BigDecimal.new('1.04058') },
    { id: 2, euro_conversion_rate: BigDecimal.new('1.04058') },
    { id: 3, euro_conversion_rate: BigDecimal.new('1.04058') },
    { id: 4, euro_conversion_rate: BigDecimal.new('1.19740') },
    { id: 5, euro_conversion_rate: BigDecimal.new('1.22850') },
    { id: 6, euro_conversion_rate: BigDecimal.new('1.20744') }
  ]

  def lending_limits
    LendingLimit.where(phase_id: id)
  end

  def name
    "Phase #{id}"
  end
end
