class EligibilityValidator < Validator
  def validate
    add_error(:viable_proposition) unless object.viable_proposition
    add_error(:would_you_lend) unless object.would_you_lend
    add_error(:collateral_exhausted) unless object.collateral_exhausted
    add_error(:previous_borrowing) unless object.previous_borrowing
    add_error(:private_residence_charge_required) if object.private_residence_charge_required
    add_error(:sic_code) unless object.sic.try(:eligible?)
    add_error(:trading_date) if object.trading_date > Date.current.advance(months: 6)
    add_error(:reason_id) unless object.reason.try(:eligible?)
  end
end
