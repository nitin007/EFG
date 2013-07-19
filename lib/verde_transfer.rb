class VerdeTransfer
  def self.run(old_lender, new_lender, loan_references)
    self.new(old_lender, new_lender, loan_references).run
  end

  def initialize(old_lender, new_lender, loan_references)
    @old_lender = old_lender
    @new_lender = new_lender
    @loan_references = loan_references
    @lending_limits = {}
  end

  def run
    loans.each do |loan|
      transfer_loan(loan)
    end
  end

  private

  def lending_limit(loan)
    key = loan.lending_limit_id

    unless lending_limits.has_key?(key)
      lending_limits[key] = clone_lending_limit(loan.lending_limit)
    end

    lending_limits[key]
  end

  def clone_lending_limit(existing)
    new_lender.lending_limits.create! do |lending_limit|
      lending_limit.modified_by = system_user

      lending_limit_attributes.each do |attr|
        lending_limit.send("#{attr}=", existing.send(attr))
      end
    end
  end

  def lending_limit_attributes
    @lending_limit_attributes ||= [
      :allocation_type_id, :active, :allocation, :starts_on,
      :ends_on, :name, :premium_rate, :guarantee_rate, :phase_id
    ]
  end

  def loans
    @loans ||= old_lender.loans.where(reference: loan_references)
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

  attr_reader :old_lender, :new_lender, :loan_references, :lending_limits
end
