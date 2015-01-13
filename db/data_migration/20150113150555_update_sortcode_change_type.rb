# This is intended to provide a mechanism by which relatively expensive data
# updates can be decoupled from deployment time and run independently.
#
# This will execute within an ActiveRecord transaction and is instance_eval-ed.
# Just write normal ruby code and refer to any model objects that you require.
# Since a data migration is intended to be run in production, when the schema
# and model are known quantities, it should be fine to reference model classes
# directly, even though in the future they may be refactored or deleted
# entirely.

# Set the correct change type on sort code data corrections
# but only if they don't have any other data corrections
fields = [
  :maturity_date,
  :old_maturity_date,
  :business_name,
  :old_business_name,
  :lump_sum_repayment,
  :amount_drawn,
  :amount,
  :old_amount,
  :facility_letter_date,
  :old_facility_letter_date,
  :initial_draw_date,
  :old_initial_draw_date,
  :initial_draw_amount,
  :old_initial_draw_amount,
  :dti_demand_out_amount,
  :old_dti_demand_out_amount,
  :dti_demand_interest,
  :old_dti_demand_interest,
  :lending_limit_id,
  :old_lending_limit_id,
  :repayment_duration,
  :old_repayment_duration,
  :repayment_frequency_id,
  :old_repayment_frequency_id,
  :postcode,
  :old_postcode,
  :lender_reference,
  :old_lender_reference,
  :old_trading_name,
  :trading_name,
]

scope = LoanModification.where(change_type_id: ChangeType::DataCorrection.id).
          where('sortcode is not null OR old_sortcode is not null')

scope = fields.inject(scope) do |memo, field|
  memo.where("#{field} is null")
end

scope.each_with_index do |loan_modification, index|
  puts index + 1
  puts loan_modification.inspect
  loan_modification.change_type = ChangeType::Sortcode
  loan_modification.save!
  puts loan_modification.change_type
  puts '----------'
end
