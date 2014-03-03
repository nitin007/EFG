# encoding: utf-8

class LoanAmountRepaymentDurationValidator
  FIVE_YEARS = 60
  ONE_POINT_TWO_MILLION = Money.new(1_200_000_00)
  SIX_HUNDRED_THOUSAND = Money.new(600_000_00)

  def initialize(object)
    @object = object
  end

  def validate
    if amount > ONE_POINT_TWO_MILLION
      errors.add(:amount, 'TODO maximum loan amount is £1.2m')
    elsif amount > SIX_HUNDRED_THOUSAND && repayment_duration > FIVE_YEARS
      errors.add(:repayment_duration, 'TODO: loan term cannot be longer than 5 years for a facility greater than £600k')
    end
  end

  private
    attr_reader :object

    delegate :amount, :errors, :repayment_duration, to: :object
end
