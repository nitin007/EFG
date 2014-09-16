require 'spec_helper'

describe PostcodeDataCorrection do
  describe 'validations' do
    let(:presenter) { FactoryGirl.build(:postcode_data_correction) }

    it 'has a valid factory' do
      presenter.should be_valid
    end

    it 'requires a postcode' do
      presenter.postcode = ''
      presenter.should_not be_valid
    end
  end

  describe '#save' do
    let(:user) { FactoryGirl.create(:lender_user) }
    let(:loan) { FactoryGirl.create(:loan, :guaranteed, postcode: 'EC1R 4RP') }
    let(:presenter) { FactoryGirl.build(:postcode_data_correction, created_by: user, loan: loan) }

    context 'success' do
      it 'creates a DataCorrection and updates the loan' do
        presenter.postcode = 'EC1A 9PN'
        presenter.save.should == true

        data_correction = loan.data_corrections.last!
        data_correction.created_by.should == user
        data_correction.change_type.should == ChangeType::Postcode
        data_correction.postcode.should == 'EC1A 9PN'
        data_correction.old_postcode.should == 'EC1R 4RP'

        loan.reload
        loan.postcode.should == 'EC1A 9PN'
        loan.modified_by.should == user
      end
    end

    context 'failure' do
      it 'does not update loan' do
        presenter.postcode = nil
        presenter.save.should == false

        loan.reload
        loan.postcode.should == 'EC1R 4RP'
      end
    end
  end
end
