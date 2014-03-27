class AddExtraEligibilityQuestionToLoans < ActiveRecord::Migration
  def change
    add_column :loans, :not_insolvent, :boolean
  end
end
