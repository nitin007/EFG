class MoveDataCorrectionsOutOfLoanModifications < ActiveRecord::Migration
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

    data_correction_columns = [
      'loan_id',
      'created_by_id',
      'change_type_id',
      'oid',
      'seq',
      'date_of_change',
      'modified_date',
      'modified_user',
      'ar_timestamp',
      'ar_insert_timestamp',
      'created_at',
      'updated_at',
    ].concat(data_correction_legacy_columns)

    # Move data corrections out of loan modifications
    conditions = data_correction_legacy_columns.map { |column| "#{column} IS NOT NULL" }.join(" OR ")

    loan_modifications = execute("
      SELECT #{data_correction_columns.join(',')}
        FROM loan_modifications
       WHERE #{conditions}
         AND type IN ('DataCorrection', 'LoanChange')
    ")

    loan_modifications.each(as: :hash) do |mod|
      populated_columns = mod.select { |key, value| value.present? }

      populated_columns = populated_columns.each_with_object({}) do |(key, value), memo|
        memo[key] = value.is_a?(Date) || value.is_a?(Time) ? value.to_s(:db) : value.to_s
      end

      execute("
        INSERT INTO data_corrections (#{populated_columns.keys.join(',')})
        VALUES ('#{populated_columns.values.join("','")}')
      ")
    end
  end

  def down
  end
end
