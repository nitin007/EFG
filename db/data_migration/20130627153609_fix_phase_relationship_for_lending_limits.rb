# This is intended to provide a mechanism by which relatively expensive data
# updates can be decoupled from deployment time and run independently.
#
# This will execute within an ActiveRecord transaction and is instance_eval-ed.
# Just write normal ruby code and refer to any model objects that you require.
# Since a data migration is intended to be run in production, when the schema
# and model are known quantities, it should be fine to reference model classes
# directly, even though in the future they may be refactored or deleted
# entirely.

LendingLimit.update_all(phase_id: nil)

phase1 = Phase.find_by_name!('Phase 1')
phase2 = Phase.find_by_name!('Phase 2')
phase3 = Phase.find_by_name!('Phase 3')
phase4 = Phase.find_by_name!('Phase 4')
phase5 = Phase.find_by_name!('Phase 5')

{
  'EFG Base FY 2009/10' => phase1,
  'FY 2009/10 CDFI A' => phase1,
  'Base 2008/09' => phase1,
  'SFLG Transfer 2009/10' => phase1,
  'Transfer 2008/09' => phase1,
  'Corporate EFG Base FY 2010/11' => phase2,
  'EFG Base FY 2010/11' => phase2,
  'EFG Extended FY 2010/11 Limit' => phase2,
  'SFLG Transfer FY 2010/11' => phase2,
  'SFLG Transfer FY 2011/12' => phase3,
  'Corporate EFG Base FY 2011/12' => phase3,
  'EFG Base FY 2011/12' => phase3,
  'EFG Extended FY 2012/13 Limit' => phase4,
  'SFLG Transfer FY 2012/13' => phase4,
  'Corporate EFG Base FY 2012/13' => phase4,
  'EFG Base FY 2012/13' => phase4,
  'EFG Base FY 2013/14' => phase5
}.each do |lending_limit_name, phase|
  LendingLimit.where(name: lending_limit_name).update_all(phase_id: phase.id)
end
