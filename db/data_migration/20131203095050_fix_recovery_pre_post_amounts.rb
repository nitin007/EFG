# This is intended to provide a mechanism by which relatively expensive data
# updates can be decoupled from deployment time and run independently.
#
# This will execute within an ActiveRecord transaction and is instance_eval-ed.
# Just write normal ruby code and refer to any model objects that you require.
# Since a data migration is intended to be run in production, when the schema
# and model are known quantities, it should be fine to reference model classes
# directly, even though in the future they may be refactored or deleted
# entirely.

# EFZXS4D+01
LoanRealisation.find(3857).update_column(:post_claim_limit, false) # Was true.

# XCA6DT5+01
LoanRealisation.find(3940).update_column(:realised_amount, 0)               # Was 92826.
LoanRealisation.find(3941).update_column(:realised_amount, 0)               # Was 2037744.
Loan.find(93400).update_column(:realised_money_date, Date.new(2013, 4, 19)) # Was 2013-05-01.

# WQ88KPE+01
LoanRealisation.find(3924).update_column(:post_claim_limit, false) # Was true.

# JDDPDWY+01
LoanRealisation.find(3930).update_column(:post_claim_limit, false) # Was true.

# VHFCPJ8+01
LoanRealisation.find(3928).update_column(:post_claim_limit, false) # Was true.

# 2ME5GEE+01
LoanRealisation.find(3921).update_column(:post_claim_limit, false) # Was true.

# TR4GJYB+01
LoanRealisation.find(2411).update_column(:realised_amount, 0)     # Was 5348.
LoanRealisation.find(2420).update_column(:realised_amount, 0)     # Was 8022.
LoanRealisation.find(2542).update_column(:realised_amount, 0)     # Was 13370.
LoanRealisation.find(2662).update_column(:realised_amount, 0)     # Was 5518.
LoanRealisation.find(3865).update_column(:realised_amount, 14278) # Was 1871.

# L2FXSPP+01
LoanRealisation.find(2422).update_column(:post_claim_limit, true) # Was false.
LoanRealisation.find(2544).update_column(:post_claim_limit, true) # Was false.
LoanRealisation.find(2664).update_column(:post_claim_limit, true) # Was false.
LoanRealisation.find(2667).update_column(:post_claim_limit, true) # Was false.

# AK4NWQR+01
LoanRealisation.find(3868).update_column(:realised_amount, 0)   # Was 5250.
LoanRealisation.find(3869).update_column(:realised_amount, 0)   # Was 2625.
LoanRealisation.find(3953).update_column(:realised_amount, 0)   # Was 2625.
LoanRealisation.find(3954).update_column(:realised_amount, 0)   # Was 2625.
LoanRealisation.find(3955).update_column(:realised_amount, 0)   # Was 2625.
LoanRealisation.find(4181).update_column(:realised_amount, 0)   # Was 2625.
LoanRealisation.find(4182).update_column(:realised_amount, 0)   # Was 2625.
LoanRealisation.find(4183).update_column(:realised_amount, 0)   # Was 2625.
LoanRealisation.find(4184).update_column(:realised_amount, 0)   # Was 2625.
LoanRealisation.find(4185).update_column(:realised_amount, 0)   # Was 2625.
LoanRealisation.find(4186).update_column(:realised_amount, 0)   # Was 2625.
LoanRealisation.find(4187).update_column(:realised_amount, 375) # Was 2625.

# ZLJ4U42+01
LoanRealisation.find(3949).update_column(:realised_amount, 0) # Was 5250.
LoanRealisation.find(4176).update_column(:realised_amount, 0) # Was 5250.
LoanRealisation.find(4177).update_column(:realised_amount, 0) # Was 5250.
