class RemoveDataCorrectionColumnsFromLoanModifications < ActiveRecord::Migration

  DataCorrectionLegacyColumns = {
    _legacy_business_name: { type: :string, options: {} },
    _legacy_old_business_name: { type: :string, options: {} },
    _legacy_facility_letter_date: { type: :date, options: {} },
    _legacy_old_facility_letter_date: { type: :date, options: {} },
    _legacy_sortcode: { type: :string, options: {} },
    _legacy_old_sortcode: { type: :string, options: {} },
    _legacy_dti_demand_outstanding: { type: :integer, options: { limit: 8 } },
    _legacy_old_dti_demand_outstanding: { type: :integer, options: { limit: 8 } },
    _legacy_dti_interest: { type: :integer, options: { limit: 8} },
    _legacy_old_dti_interest: { type: :integer, options: { limit: 8 } },
    _legacy_lending_limit_id: { type: :integer, options: {} },
    _legacy_old_lending_limit_id: { type: :integer, options: {} },
    _legacy_postcode: { type: :string, options: {} },
    _legacy_old_postcode: { type: :string, options: {} },
    _legacy_lender_reference: { type: :string, options: {} },
    _legacy_old_lender_reference: { type: :string, options: {} },
  }

  def up
    drop_statements = DataCorrectionLegacyColumns.keys.map do |column_name|
      "DROP COLUMN #{column_name}"
    end

    execute("ALTER TABLE loan_modifications #{drop_statements.join(',')}")

    execute("UPDATE loan_modifications SET type ='LoanChange' WHERE type = 'DataCorrection'")
  end

  def down
    DataCorrectionLegacyColumns.each do |column_name, config|
      add_column :loan_modifications, column_name, config[:type], config[:options]
    end
  end
end
