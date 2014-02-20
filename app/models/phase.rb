class Phase < StaticAssociation
  self.data = [
    { id: 1 },
    { id: 2 },
    { id: 3 },
    { id: 4 },
    { id: 5 },
    { id: 6 }
  ]

  def lending_limits
    LendingLimit.where(phase_id: id)
  end

  def name
    "Phase #{id}"
  end
end
