class AddLenderReferenceToLoanModifications < ActiveRecord::Migration
  def change
    add_column :loan_modifications, :lender_reference, :string
    add_column :loan_modifications, :old_lender_reference, :string
  end
end
