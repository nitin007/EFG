class MoveDataCorrectionsOutOfLoanModifications < ActiveRecord::Migration

  COLUMNS_TO_MIGRATE = [
    { name: "business_name", old_column: "_legacy_old_business_name", new_column: "_legacy_business_name" },
    { name: "facility_letter_date", old_column: "_legacy_old_facility_letter_date", new_column: "_legacy_facility_letter_date" },
    { name: "sortcode", old_column: "_legacy_old_sortcode", new_column: "_legacy_sortcode" },
    { name: "dti_demand_outstanding", old_column: "_legacy_old_dti_demand_outstanding", new_column: "_legacy_dti_demand_outstanding" },
    { name: "dti_interest", old_column: "_legacy_old_dti_interest", new_column: "_legacy_dti_interest" },
    { name: "lending_limit_id", old_column: "_legacy_old_lending_limit_id", new_column: "_legacy_lending_limit_id" },
    { name: "postcode", old_column: "_legacy_old_postcode", new_column: "_legacy_postcode" },
    { name: "lender_reference", old_column: "_legacy_old_lender_reference", new_column: "_legacy_lender_reference" },
  ]

  DATA_CORRECTION_LEGACY_COLUMNS = [
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

  DATA_CORRECTION_COLUMNS = [
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
  ].concat(DATA_CORRECTION_LEGACY_COLUMNS)

  def up
    conditions = DATA_CORRECTION_LEGACY_COLUMNS.map do |column|
      "#{column} IS NOT NULL"
    end.join(" OR ")

    loan_modifications = execute("
      SELECT #{DATA_CORRECTION_COLUMNS.join(',')}
        FROM loan_modifications
       WHERE #{conditions}
         AND type IN ('DataCorrection', 'LoanChange')
    ")

    values = []

    loan_modifications.each(as: :hash) do |mod|
      row_values = mod.values.map { |value| format_value(value) }
      row_values << build_changes_json(mod)

      values << "(#{row_values.join(",")})"
    end

    execute("
      INSERT INTO data_corrections (#{DATA_CORRECTION_COLUMNS.join(',')}, data_correction_changes)
      VALUES #{values.join(",")}
    ")
  end

  def down
    data_corrections = execute("SELECT #{DATA_CORRECTION_COLUMNS.join(',')} FROM data_corrections")

    values = []
    max_sequences = {}

    data_corrections.each(as: :hash) do |data_correction|
      loan_id = data_correction['loan_id']

      # ensure load_id and seq are unique to satisfy index
      unless max_sequences.has_key?(loan_id)
        max_sequence_result = execute("
          SELECT MAX(seq)
          FROM loan_modifications
          WHERE loan_id = #{loan_id}
        ")
        max_sequences[loan_id] = max_sequence_result.first.first
      end

      row_values = data_correction.each_with_object([]) do |(key, value), memo|
        if key == 'seq'
          max_sequences[loan_id] += 1
          value = max_sequences[loan_id]
        end

        memo << format_value(value)
      end

      # for type column
      row_values << format_value('DataCorrection')

      values << "(#{row_values.join(",")})"
    end

    execute("
      INSERT INTO loan_modifications (#{DATA_CORRECTION_COLUMNS.join(',')}, type)
      VALUES #{values.join(",")}
    ")
  end

  private

  def build_changes_json(loan_modification)
    extracted_changes = COLUMNS_TO_MIGRATE.each_with_object({}) do |attribute, memo|
      old_value = loan_modification[attribute[:old_column]]
      new_value = loan_modification[attribute[:new_column]]
      memo[attribute[:name]] = [ old_value, new_value ] if new_value or old_value
    end

    if extracted_changes.any?
      ActiveRecord::Base.connection.quote(ActiveSupport::JSON.encode(extracted_changes))
    end
  end

  def format_value(value)
    if value.is_a?(Date) || value.is_a?(Time)
      ActiveRecord::Base.connection.quote(value.to_s(:db))
    elsif value.present?
      ActiveRecord::Base.connection.quote(value.to_s)
    else
      'NULL'
    end
  end
end
