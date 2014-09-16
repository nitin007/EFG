require 'spec_helper'

describe 'Sortcode Data Correction' do
  include DataCorrectionSpecHelper

  let(:loan) { FactoryGirl.create(:loan, :guaranteed, lender: current_user.lender, sortcode: '123456') }

  before do
    visit_data_corrections
    click_link 'Sortcode'
  end

  it do
    fill_in 'sortcode', '654321'
    click_button 'Submit'

    data_correction = loan.data_corrections.last!
    data_correction.change_type.should == ChangeType::DataCorrection
    data_correction.created_by.should == current_user
    data_correction.date_of_change.should == Date.current
    data_correction.modified_date.should == Date.current
    data_correction.old_sortcode.should == '123456'
    data_correction.sortcode.should == '654321'

    loan.reload
    loan.sortcode.should == '654321'
    loan.modified_by.should == current_user
  end
end
