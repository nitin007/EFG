class VerdeTransfer
  def self.run(loans, new_lender)
    self.new(loans, new_lender).run
  end

  def initialize(loans, new_lender)
    @loans = loans
    @new_lender = new_lender
  end

  def run
    loans.each do |loan|
      transfer_loan(loan)
    end
  end

  private

  def new_lending_limit(loan)
    new_lender.lending_limits.where(name: loan.lending_limit.name).first
  end

  def system_user
    @system_user ||= SystemUser.first
  end

  def transfer_loan(loan)
    loan.lender = new_lender
    loan.lending_limit = new_lending_limit(loan) if loan.lending_limit
    loan.modified_by = system_user

    loan.state_changes.create!(
      state: loan.state,
      event_id: LoanEvent::EFGTransfer.id,
      modified_at: Time.now,
      modified_by: system_user
    )

    loan.save!
  end

  attr_reader :loans, :new_lender
end
