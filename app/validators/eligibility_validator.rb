class EligibilityValidator < Validator
  def validate
    add_error(:viable_proposition) unless object.viable_proposition?
    add_error(:would_you_lend) unless object.would_you_lend?
    add_error(:collateral_exhausted) unless object.collateral_exhausted?
    add_error(:amount) unless object.amount.between?(Money.new(1_000_00), Money.new(1_000_000_00))
    add_error(:previous_borrowing) unless object.previous_borrowing?
    add_error(:private_residence_charge_required) if object.private_residence_charge_required?
    add_error(:sic_code) unless object.sic_eligible?
    add_error(:trading_date) if object.trading_date > Date.current.advance(months: 6)
    add_error(:reason_id) unless object.reason.eligible?

    if object.repayment_duration.blank?
      add_error(:repayment_duration)
    else
      repayment_duration = RepaymentDuration.new(object)

      unless object.repayment_duration.total_months.between?(repayment_duration.min_months, repayment_duration.max_months)
        add_error(:repayment_duration)
      end
    end
  end
end
