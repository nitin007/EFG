class LoanIneligibilityReason < ActiveRecord::Base

  belongs_to :loan

  validates_presence_of :loan_id, strict: true
  validates_presence_of :reason

  attr_accessible :reason

end
