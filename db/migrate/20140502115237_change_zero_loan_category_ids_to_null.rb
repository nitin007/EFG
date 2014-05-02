class ChangeZeroLoanCategoryIdsToNull < ActiveRecord::Migration
  def up
    execute 'UPDATE loans SET loan_category_id = NULL WHERE loan_category_id = 0'
  end

  def down
    execute 'UPDATE loans SET loan_category_id = 0 WHERE loan_category_id = NULL'
  end
end
