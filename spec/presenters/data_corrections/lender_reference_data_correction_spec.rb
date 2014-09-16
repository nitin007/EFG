require 'spec_helper'

describe LenderReferenceDataCorrection do
  describe 'validations' do
    let(:presenter) { FactoryGirl.build(:lender_reference_data_correction) }

    it 'has a valid factory' do
      presenter.should be_valid
    end

    it 'requires a lender_reference' do
      presenter.lender_reference = ''
      presenter.should_not be_valid
    end
  end

  describe '#save' do
    let(:user) { FactoryGirl.create(:lender_user) }
    let(:loan) { FactoryGirl.create(:loan, :guaranteed, lender_reference: 'Foo') }
    let(:presenter) { FactoryGirl.build(:lender_reference_data_correction, created_by: user, loan: loan) }

    context 'success' do
      it 'creates a DataCorrection and updates the loan' do
        presenter.lender_reference = 'Bar'
        presenter.save.should == true

        data_correction = loan.data_corrections.last!
        data_correction.created_by.should == user
        data_correction.change_type.should == ChangeType::LenderReference
        data_correction.lender_reference.should == 'Bar'
        data_correction.old_lender_reference.should == 'Foo'

        loan.reload
        loan.lender_reference.should == 'Bar'
        loan.modified_by.should == user
      end
    end

    context 'failure' do
      it 'does not update loan' do
        presenter.lender_reference = nil
        presenter.save.should == false
        loan.reload

        loan.lender_reference.should == 'Foo'
      end
    end
  end
end
