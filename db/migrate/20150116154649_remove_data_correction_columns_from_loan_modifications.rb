class RemoveDataCorrectionColumnsFromLoanModifications < ActiveRecord::Migration
  def up
    data_correction_legacy_columns = [
      '_legacy_business_name',
      '_legacy_old_business_name',
      '_legacy_facility_letter_date',
      '_legacy_old_facility_letter_date',
      '_legacy_sortcode',
      '_legacy_old_sortcode',
      '_legacy_dti_demand_outstanding',
      '_legacy_old_dti_demand_outstanding',
      '_legacy_dti_interest',
      '_legacy_old_dti_interest',
      '_legacy_lending_limit_id',
      '_legacy_old_lending_limit_id',
      '_legacy_postcode',
      '_legacy_old_postcode',
      '_legacy_lender_reference',
      '_legacy_old_lender_reference',
    ]

    data_correction_legacy_columns.each do |column_name|
      remove_column :loan_modifications, column_name
    end

    LoanModification.where(type: ['DataCorrection']).update_all(type: 'LoanChange')
  end

  def down
  end
end
