# This is intended to provide a mechanism by which relatively expensive data
# updates can be decoupled from deployment time and run independently.
#
# This will execute within an ActiveRecord transaction and is instance_eval-ed.
# Just write normal ruby code and refer to any model objects that you require.
# Since a data migration is intended to be run in production, when the schema
# and model are known quantities, it should be fine to reference model classes
# directly, even though in the future they may be refactored or deleted
# entirely.

require 'verde_transfer'

references = %w(25ZDAUX+01 5ZCGETP+01 8P2DNHC+01 NRLJ4FP+01 V2S5RFD+01)
old_lender = Lender.find(19)
new_lender = Lender.find(39)

VerdeTransfer.run(old_lender, new_lender, references)
