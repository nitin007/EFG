class VerdeTransfer
  def self.run(old_lender, new_lender, loan_references)
    self.new(old_lender, new_lender, loan_references).run
  end

  def initialize(old_lender, new_lender, loan_references)
    @old_lender = old_lender
    @new_lender = new_lender
    @loan_references = loan_references
  end

  def run
    loans.each do |loan|
      transfer_loan(loan)
    end
  end

  private

  def lending_limit(loan)
    new_lender.lending_limits.where(name: loan.lending_limit.name).first
  end

  def loans
    @loans ||= old_lender.loans.where(reference: loan_references).to_a
  end

  def system_user
    @system_user ||= SystemUser.first
  end

  def transfer_loan(loan)
    loan.lender = new_lender
    loan.lending_limit = lending_limit(loan) if loan.lending_limit
    loan.modified_by = system_user

    loan.state_changes.create!(
      state: loan.state,
      event_id: LoanEvent::EFGTransfer.id,
      modified_at: Time.now,
      modified_by: system_user
    )

    loan.save!
  end

  attr_reader :old_lender, :new_lender, :loan_references
end
