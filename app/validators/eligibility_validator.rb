class EligibilityValidator < BaseValidator
  def validate(record)
    add_error(record, :viable_proposition) unless record.viable_proposition
    add_error(record, :would_you_lend) unless record.would_you_lend
    add_error(record, :collateral_exhausted) unless record.collateral_exhausted
    add_error(record, :not_insolvent) unless record.not_insolvent
    add_error(record, :previous_borrowing) unless record.previous_borrowing
    add_error(record, :private_residence_charge_required) if record.private_residence_charge_required
    add_error(record, :sic_code) unless record.sic.try(:eligible?)
    add_error(record, :trading_date) if record.trading_date > Date.current.advance(months: 6)
    add_error(record, :reason_id) unless record.reason.try(:eligible?)
  end
end
