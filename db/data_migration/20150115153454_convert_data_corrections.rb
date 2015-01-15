# This is intended to provide a mechanism by which relatively expensive data
# updates can be decoupled from deployment time and run independently.
#
# This will execute within an ActiveRecord transaction and is instance_eval-ed.
# Just write normal ruby code and refer to any model objects that you require.
# Since a data migration is intended to be run in production, when the schema
# and model are known quantities, it should be fine to reference model classes
# directly, even though in the future they may be refactored or deleted
# entirely.

columns_to_migrate = [
  OpenStruct.new(name: "business_name", old_column: "_legacy_old_business_name", new_column: "_legacy_business_name"),
  OpenStruct.new(name: "facility_letter_date", old_column: "_legacy_old_facility_letter_date", new_column: "_legacy_facility_letter_date"),
  OpenStruct.new(name: "sortcode", old_column: "_legacy_old_sortcode", new_column: "_legacy_sortcode"),
  OpenStruct.new(name: "dti_demand_outstanding", old_column: "_legacy_old_dti_demand_outstanding", new_column: "_legacy_dti_demand_outstanding"),
  OpenStruct.new(name: "dti_interest", old_column: "_legacy_old_dti_interest", new_column: "_legacy_dti_interest"),
  OpenStruct.new(name: "lending_limit_id", old_column: "_legacy_old_lending_limit_id", new_column: "_legacy_lending_limit_id"),
  OpenStruct.new(name: "postcode", old_column: "_legacy_old_postcode", new_column: "_legacy_postcode"),
  OpenStruct.new(name: "lender_reference", old_column: "_legacy_old_lender_reference", new_column: "_legacy_lender_reference"),
  OpenStruct.new(name: "trading_name", old_column: "_legacy_old_trading_name", new_column: "_legacy_trading_name"),
  OpenStruct.new(name: "trading_date", old_column: "_legacy_old_trading_date", new_column: "_legacy_trading_date"),
  OpenStruct.new(name: "company_registration", old_column: "_legacy_old_company_registration", new_column: "_legacy_company_registration"),
]

LoanModification.all.each do |loan_modification|
  extracted_changes = columns_to_migrate.each_with_object({}) do |attribute, memo|
    old_value = loan_modification.public_send(attribute.old_column)
    new_value = loan_modification.public_send(attribute.new_column)
    memo[attribute.name] = [ old_value, new_value ] if new_value or old_value
  end

  if extracted_changes.any?
    existing_changes = loan_modification.data_correction_changes ||= {}
    loan_modification.data_correction_changes = existing_changes.merge(extracted_changes)
    loan_modification.save!
  end
end
