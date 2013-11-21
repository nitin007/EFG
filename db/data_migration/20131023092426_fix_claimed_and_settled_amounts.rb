# This is intended to provide a mechanism by which relatively expensive data
# updates can be decoupled from deployment time and run independently.
#
# This will execute within an ActiveRecord transaction and is instance_eval-ed.
# Just write normal ruby code and refer to any model objects that you require.
# Since a data migration is intended to be run in production, when the schema
# and model are known quantities, it should be fine to reference model classes
# directly, even though in the future they may be refactored or deleted
# entirely.

require 'csv'

path_to_data = Rails.root.join('db/data_fixes/2013-10-25-claimed_and_settled_fixes.csv')
data = CSV.read(path_to_data, headers: true)
super_user = SuperUser.first

data.each do |row|
  reference              = row['Loan reference']
  dti_amount_claimed     = row['Total amount claimed under the Government Guarantee2']
  dti_demand_outstanding = row['Outstanding Scheme Facility Principal2']
  settled_amount         = row['Settled Amount2']

  loan = Loan.find_by_reference!(reference)
  loan.dti_amount_claimed = dti_amount_claimed
  loan.dti_demand_outstanding = dti_demand_outstanding
  loan.settled_amount = settled_amount
  loan.modified_by = super_user

  changes = {
    'reference' => reference
  }

  loan.changes.reject { |attribute, _|
    attribute == 'modified_by_id'
  }.each do |attribute, (previous, current)|
    # Previous value will be nil/integer, newly added value will be a Money.
    changes[attribute] = [previous, current.cents]
  end

  puts changes.to_json

  loan.save!
end
