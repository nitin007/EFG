# This is intended to provide a mechanism by which relatively expensive data
# updates can be decoupled from deployment time and run independently.
#
# This will execute within an ActiveRecord transaction and is instance_eval-ed.
# Just write normal ruby code and refer to any model objects that you require.
# Since a data migration is intended to be run in production, when the schema
# and model are known quantities, it should be fine to reference model classes
# directly, even though in the future they may be refactored or deleted
# entirely.

lender = Lender.find_by_organisation_reference_code('42')

if lender
  loans = lender.loans.where(reference: ['TSUJWQ4+02', 'G8XYP2S+02'])
  lending_limit = lender.lending_limits.find_by_name('EFG Base FY 2009/10')

  unless lending_limit.nil? || loans.empty?
    loans.each do |loan|
      loan.lending_limit = lending_limit
      loan.save!
    end
  end
end