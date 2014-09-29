class DataCorrection < LoanModification
  include FormatterConcern

  belongs_to :old_lending_limit, class_name: 'LendingLimit'
  belongs_to :lending_limit

  format :postcode, with: PostcodeFormatter
  format :old_postcode, with: PostcodeFormatter

  def old_repayment_frequency
    RepaymentFrequency.find(old_repayment_frequency_id)
  end

  def repayment_frequency
    RepaymentFrequency.find(repayment_frequency_id)
  end
end
