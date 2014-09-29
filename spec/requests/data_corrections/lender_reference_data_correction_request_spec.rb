require 'spec_helper'

describe 'Lender Reference Data Correction' do
  include DataCorrectionSpecHelper

  let(:loan) { FactoryGirl.create(:loan, :guaranteed, lender: current_user.lender, lender_reference: 'LENDER SAYS') }

  before do
    visit_data_corrections
    click_link 'Lender Reference'
  end

  it do
    fill_in 'lender_reference', 'NEW REFERENCE'
    click_button 'Submit'

    data_correction = loan.data_corrections.last!
    data_correction.change_type.should == ChangeType::LenderReference
    data_correction.created_by.should == current_user
    data_correction.date_of_change.should == Date.current
    data_correction.modified_date.should == Date.current
    data_correction.old_lender_reference.should == 'LENDER SAYS'
    data_correction.lender_reference.should == 'NEW REFERENCE'

    loan.reload
    loan.lender_reference.should == 'NEW REFERENCE'
    loan.modified_by.should == current_user
  end
end
