class MakeMoreLoanRealisationFieldsNotNull < ActiveRecord::Migration
  def up
    change_column_null :loan_realisations, :realised_loan_id, false
    change_column_null :loan_realisations, :created_by_id, false
    change_column_null :loan_realisations, :realised_amount, false
    change_column_null :loan_realisations, :post_claim_limit, false
  end

  def down
    change_column_null :loan_realisations, :realised_loan_id, true
    change_column_null :loan_realisations, :created_by_id, true
    change_column_null :loan_realisations, :realised_amount, true
    change_column_null :loan_realisations, :post_claim_limit, true
  end
end
