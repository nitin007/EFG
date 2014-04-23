class LoansStateCannotBeNull < ActiveRecord::Migration
  def up
    change_column_null :loans, :state, false
  end

  def down
    change_column_null :loans, :state, true
  end
end
