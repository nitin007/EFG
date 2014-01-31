# This is intended to provide a mechanism by which relatively expensive data
# updates can be decoupled from deployment time and run independently.
#
# This will execute within an ActiveRecord transaction and is instance_eval-ed.
# Just write normal ruby code and refer to any model objects that you require.
# Since a data migration is intended to be run in production, when the schema
# and model are known quantities, it should be fine to reference model classes
# directly, even though in the future they may be refactored or deleted
# entirely.

loan = Loan.find(80109)

loan_realisation = loan.loan_realisations.new
loan_realisation.realised_amount = Money.new(450_00)
loan_realisation.created_by = SystemUser.first
loan_realisation.realised_on = Date.today
loan_realisation.save!(validate: false)

loan_realisation = loan.loan_realisations.new
loan_realisation.realised_amount = Money.new(225_00)
loan_realisation.created_by = SystemUser.first
loan_realisation.realised_on = Date.today
loan_realisation.save!(validate: false)

recovery = loan.recoveries.find(4614)
recovery.amount_due_to_dti = Money.new(187_50)
recovery.save!
