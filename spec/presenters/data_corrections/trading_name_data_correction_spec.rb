require 'spec_helper'

describe TradingNameDataCorrection do
  describe 'validations' do
    let(:presenter) { FactoryGirl.build(:trading_name_data_correction) }

    it 'has a valid factory' do
      presenter.should be_valid
    end

    it 'requires a trading_name' do
      presenter.trading_name = ''
      presenter.should_not be_valid
    end
  end

  describe '#save' do
    let(:user) { FactoryGirl.create(:lender_user) }
    let(:loan) { FactoryGirl.create(:loan, :guaranteed, trading_name: 'Foo') }
    let(:presenter) { FactoryGirl.build(:trading_name_data_correction, created_by: user, loan: loan) }

    context 'success' do
      it 'creates a DataCorrection and updates the loan' do
        presenter.trading_name = 'Bar'
        presenter.save.should == true

        data_correction = loan.data_corrections.last!
        data_correction.created_by.should == user
        data_correction.change_type.should == ChangeType::TradingName
        data_correction.trading_name.should == 'Bar'
        data_correction.old_trading_name.should == 'Foo'

        loan.reload
        loan.trading_name.should == 'Bar'
        loan.modified_by.should == user
      end
    end

    context 'failure' do
      it 'does not update loan' do
        presenter.trading_name = nil
        presenter.save.should == false
        loan.reload

        loan.trading_name.should == 'Foo'
      end
    end
  end
end