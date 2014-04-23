class LoanIneligibilityReasonsBelongToALoan < ActiveRecord::Migration
  def up
    execute 'DELETE FROM loan_ineligibility_reasons WHERE loan_id IS NULL'

    change_column_null :loan_ineligibility_reasons, :loan_id, false
  end

  def down
    change_column_null :loan_ineligibility_reasons, :loan_id, true
  end
end
