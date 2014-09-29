require 'spec_helper'

describe 'Business Name Data Correction' do
  include DataCorrectionSpecHelper

  let(:loan) { FactoryGirl.create(:loan, :guaranteed, lender: current_user.lender, business_name: 'Foo') }

  before do
    visit_data_corrections
    click_link 'Business Name'
  end

  it do
    fill_in 'business_name', 'Bar'
    click_button 'Submit'

    data_correction = loan.data_corrections.last!
    data_correction.change_type.should == ChangeType::BusinessName
    data_correction.created_by.should == current_user
    data_correction.date_of_change.should == Date.current
    data_correction.modified_date.should == Date.current
    data_correction.old_business_name.should == 'Foo'
    data_correction.business_name.should == 'Bar'

    loan.reload
    loan.business_name.should == 'Bar'
    loan.modified_by.should == current_user
  end
end
