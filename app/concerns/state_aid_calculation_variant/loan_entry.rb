module StateAidCalculationVariant::LoanEntry
  include StateAidCalculationVariant::Base

  def self.to_param
    'loan_entry'
  end

  def leave_state_aid_calculation_path(loan)
    new_loan_entry_path(loan)
  end
end
