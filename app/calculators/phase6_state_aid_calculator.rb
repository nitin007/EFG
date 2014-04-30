class Phase6StateAidCalculator
  ConservativeEuroConversionRate = 1.25
  MaximumStateAidAmount = Money.new(200_000_00, 'EUR')
  MaxLoanAmount = Money.new(1_200_000_00)
  MaxRepaymentDuration = 60.0

  attr_reader :loan

  def initialize(loan)
    @loan = loan
  end

  def state_aid_eur
    MaximumStateAidAmount *
      (amount / MaxLoanAmount) *
        (repayment_duration / MaxRepaymentDuration) *
          (euro_conversion_rate / ConservativeEuroConversionRate)
  end

  private
    def amount
      loan.amount || Money.new(0)
    end

    def repayment_duration
      loan.repayment_duration.try(:total_months) || 0
    end

    def euro_conversion_rate
      loan.euro_conversion_rate
    end
end
