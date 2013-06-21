class RepaymentFrequency < StaticAssociation
  self.data = [
    {
      id: 0,
      name: 'Legacy Monthly',
      months_per_repayment_period: 1
    },
    {
      id: 1,
      name: 'Annually',
      months_per_repayment_period: 12
    },
    {
      id: 2,
      name: 'Six Monthly',
      months_per_repayment_period: 6
    },
    {
      id: 3,
      name: 'Quarterly',
      months_per_repayment_period: 3
    },
    {
      id: 4,
      name: 'Monthly',
      months_per_repayment_period: 1
    },
    {
      id: 5,
      name: 'Interest Only - Single Repayment on Maturity',
    }
  ]

  LegacyMonthly = find(0)
  Annually = find(1)
  SixMonthly = find(2)
  Quarterly = find(3)
  Monthly = find(4)
  InterestOnly = find(5)

  def self.selectable
    all.dup.tap do |repayment_frequencies|
      repayment_frequencies.delete(LegacyMonthly)
    end
  end
end
