require 'spec_helper'

describe LoanModification do
  describe '#changes' do
    let(:loan_change) { FactoryGirl.build(:loan_change, :repayment_frequency) }

    it 'contains only fields that have a value' do
      loan_change.old_repayment_frequency_id = RepaymentFrequency::Monthly.id
      loan_change.repayment_frequency_id = RepaymentFrequency::Annually.id

      loan_change.changes.size.should == 1
      loan_change.changes.first[:old_attribute].should == 'old_repayment_frequency'
      loan_change.changes.first[:old_value].should == RepaymentFrequency::Monthly
      loan_change.changes.first[:attribute].should == 'repayment_frequency'
      loan_change.changes.first[:value].should == RepaymentFrequency::Annually
    end

    it 'contains fields where the old value was NULL' do
      loan_change.old_repayment_frequency_id = nil
      loan_change.repayment_frequency_id = RepaymentFrequency::Quarterly.id

      loan_change.changes.size.should == 1
      loan_change.changes.first[:old_attribute].should == 'old_repayment_frequency'
      loan_change.changes.first[:old_value].should == nil
      loan_change.changes.first[:attribute].should == 'repayment_frequency'
      loan_change.changes.first[:value].should == RepaymentFrequency::Quarterly
    end
  end
end
