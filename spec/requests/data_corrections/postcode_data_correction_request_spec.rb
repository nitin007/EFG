require 'spec_helper'

describe 'Postcode Data Correction' do
  include DataCorrectionSpecHelper

  let(:loan) { FactoryGirl.create(:loan, :guaranteed, lender: current_user.lender, postcode: 'EC1R 4RP') }

  before do
    visit_data_corrections
    click_link 'Postcode'
  end

  it do
    fill_in 'postcode', 'EC1A 9PN'
    click_button 'Submit'

    data_correction = loan.data_corrections.last!
    data_correction.change_type.should == ChangeType::Postcode
    data_correction.created_by.should == current_user
    data_correction.date_of_change.should == Date.current
    data_correction.modified_date.should == Date.current
    data_correction.old_postcode.should == 'EC1R 4RP'
    data_correction.postcode.should == 'EC1A 9PN'

    loan.reload
    loan.postcode.should == 'EC1A 9PN'
    loan.modified_by.should == current_user
  end
end
