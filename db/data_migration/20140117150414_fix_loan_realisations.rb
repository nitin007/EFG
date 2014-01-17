# This is intended to provide a mechanism by which relatively expensive data
# updates can be decoupled from deployment time and run independently.
#
# This will execute within an ActiveRecord transaction and is instance_eval-ed.
# Just write normal ruby code and refer to any model objects that you require.
# Since a data migration is intended to be run in production, when the schema
# and model are known quantities, it should be fine to reference model classes
# directly, even though in the future they may be refactored or deleted
# entirely.

super_user = SuperUser.first!

loan = Loan.find(87276)

existing_realisation = loan.loan_realisations_pre_claim_limit.first!
existing_realisation.update_column :realised_amount, 1_125_18

realisation = loan.loan_realisations_post_claim_limit.new
realisation.created_by = super_user
realisation.realised_amount = Money.new(7_274_82)
realisation.realised_on = existing_realisation.realised_on

# The existing realisation doesn't belong to a realisation statement which is
# invalid in the current app. Save without validations now and later blow up if
# it wasn't persisted.
realisation.save(validate: false)

raise 'something went wrong' unless realisation.persisted?
