# This is intended to provide a mechanism by which relatively expensive data
# updates can be decoupled from deployment time and run independently.
#
# This will execute within an ActiveRecord transaction and is instance_eval-ed.
# Just write normal ruby code and refer to any model objects that you require.
# Since a data migration is intended to be run in production, when the schema
# and model are known quantities, it should be fine to reference model classes
# directly, even though in the future they may be refactored or deleted
# entirely.


# There are some data corrections with no data changes
# due to how the old data correction form worked
# They contain no useful information and so can be safely deleted

data_correction_ids = [
  60517,
  62738,
  86206,
  60768,
  79256,
  85478,
  84077,
  77930,
  61290,
  61291,
  77264,
  97916,
  101709,
  95452,
  95453
]

DataCorrection.where(data_correction_changes: nil, id: data_correction_ids).destroy_all
