class Phase6StateAidCalculator
  ConservativeEuroConversionRate = 1.25

  MaximumStateAidAmount = Money.new(200_000_00, 'EUR')

  attr_reader :loan

  def initialize(loan)
    @loan = loan
  end

  def state_aid_eur
    MaximumStateAidAmount *
      (amount / max_loan_amount) *
        (repayment_duration / max_repayment_duration) *
          (euro_conversion_rate / ConservativeEuroConversionRate)
  end

  private
    def amount
      loan.amount || Money.new(0)
    end

    def max_loan_amount
      Money.new(1_200_000_00)
    end

    def repayment_duration
      loan.repayment_duration.total_months
    end

    def max_repayment_duration
      60.0
    end

    def euro_conversion_rate
      loan.euro_conversion_rate
    end

end
