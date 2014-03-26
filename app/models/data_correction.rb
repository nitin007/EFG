class DataCorrection < LoanModification
  include FormatterConcern

  belongs_to :old_lending_limit, class_name: 'LendingLimit'
  belongs_to :lending_limit

  format :postcode, with: PostcodeFormatter
  format :old_postcode, with: PostcodeFormatter
end
