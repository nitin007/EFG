class AddLoanSubCategoryIdToLoans < ActiveRecord::Migration
  def up
    add_column :loans, :loan_sub_category_id, :integer

    # All existing Type E loans should have a sub-category of 'Overdrafts'
    execute "UPDATE loans SET loan_sub_category_id = 1 WHERE loan_category_id = 5"
  end

  def down
    remove_column :loans, :loan_sub_category_id
  end
end
