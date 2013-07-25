# This is intended to provide a mechanism by which relatively expensive data
# updates can be decoupled from deployment time and run independently.
#
# This will execute within an ActiveRecord transaction and is instance_eval-ed.
# Just write normal ruby code and refer to any model objects that you require.
# Since a data migration is intended to be run in production, when the schema
# and model are known quantities, it should be fine to reference model classes
# directly, even though in the future they may be refactored or deleted
# entirely.

RealisationStatement.includes(:realised_loans).find_each do |realisation_statement|
  realisation_statement.realised_loans.each do |loan|
    modified_at = Range.new(realisation_statement.created_at - 5.seconds, realisation_statement.created_at + 5.seconds)

    unless loan.state_changes.where(state: Loan::Realised, modified_at: modified_at).exists?
      LoanStateChange.create!(
        loan_id: loan.id,
        state: Loan::Realised,
        modified_at: realisation_statement.created_at,
        modified_by: realisation_statement.created_by,
        event_id: LoanEvent::RealiseMoney.id
      )
    end
  end
end
