class LoanDemandToBorrower
  include LoanPresenter
  include LoanStateTransition

  transition from: Loan::Guaranteed, to: Loan::LenderDemand

  attribute :borrower_demanded_on
  attribute :borrower_demanded_amount

  validates_presence_of :borrower_demanded_amount, :borrower_demanded_on

  def borrower_demanded_on=(value)
    loan.borrower_demanded_on = QuickDateFormatter.parse(value)
  end
end
