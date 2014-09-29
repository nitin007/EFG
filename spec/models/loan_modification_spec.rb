require 'spec_helper'

describe LoanModification do
  describe '#changes' do
    let(:loan_modification) { FactoryGirl.build(:data_correction) }

    it 'contains only fields that have a value' do
      loan_modification.old_business_name = 'Foo'
      loan_modification.business_name = 'Bar'

      loan_modification.changes.size.should == 1
      loan_modification.changes.first[:old_attribute].should == 'old_business_name'
      loan_modification.changes.first[:old_value].should == 'Foo'
      loan_modification.changes.first[:attribute].should == 'business_name'
      loan_modification.changes.first[:value].should == 'Bar'
    end

    it 'contains fields where the old value was NULL' do
      loan_modification.old_lender_reference = nil
      loan_modification.lender_reference = 'LENDER REF'

      loan_modification.changes.size.should == 1
      loan_modification.changes.first[:old_attribute].should == 'old_lender_reference'
      loan_modification.changes.first[:old_value].should == nil
      loan_modification.changes.first[:attribute].should == 'lender_reference'
      loan_modification.changes.first[:value].should == 'LENDER REF'
    end
  end
end
