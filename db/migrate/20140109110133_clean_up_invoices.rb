class CleanUpInvoices < ActiveRecord::Migration
  def up
    change_column_null :invoices, :created_by_id, false
    change_column_null :invoices, :lender_id, false
    change_column_null :invoices, :period_covered_quarter, false
    change_column_null :invoices, :period_covered_year, false
    change_column_null :invoices, :received_on, false
    change_column_null :invoices, :reference, false
    change_column_null :invoices, :xref, false

    add_index :invoices, :xref, unique: true
  end

  def down
    remove_index :invoices, :xref

    change_column_null :invoices, :created_by_id, true
    change_column_null :invoices, :lender_id, true
    change_column_null :invoices, :period_covered_quarter, true
    change_column_null :invoices, :period_covered_year, true
    change_column_null :invoices, :received_on, true
    change_column_null :invoices, :reference, true
    change_column_null :invoices, :xref, true
  end
end
