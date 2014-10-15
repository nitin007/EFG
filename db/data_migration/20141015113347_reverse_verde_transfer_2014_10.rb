# This is intended to provide a mechanism by which relatively expensive data
# updates can be decoupled from deployment time and run independently.
#
# This will execute within an ActiveRecord transaction and is instance_eval-ed.
# Just write normal ruby code and refer to any model objects that you require.
# Since a data migration is intended to be run in production, when the schema
# and model are known quantities, it should be fine to reference model classes
# directly, even though in the future they may be refactored or deleted
# entirely.

if ENV['EFG_HOST'] == 'www.sflg.gov.uk'
  require 'verde_transfer'

  old_lender = Lender.find(39)
  new_lender = Lender.find(19)

  loans = [
    "MBQFNNZ+01",
    "6UXGUY4+01",
    "4ECDMZD-01",
    "8P2DNHC+01",
    "46UB7WG+01",
    "6UXGUX4+01",
  ].map { |reference|
    old_lender.loans.where(reference: reference).first
  }.compact

  VerdeTransfer.run(loans, new_lender)
end
