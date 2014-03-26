class AddPostcodeAndOldPostcodeToLoanModifications < ActiveRecord::Migration
  def change
    add_column :loan_modifications, :postcode, :string
    add_column :loan_modifications, :old_postcode, :string
  end
end
