require 'spec_helper'

describe 'premium schedule reports' do
  let(:current_user) { FactoryGirl.create(:premium_collector_user) }
  before { login_as(current_user, scope: :user) }

  let(:loan1) { FactoryGirl.create(:loan, :guaranteed) }
  let(:loan2) { FactoryGirl.create(:loan, :guaranteed) }

  before do
    FactoryGirl.create(:loan_change, loan: loan1)
    FactoryGirl.create(:loan_change, loan: loan2)
    FactoryGirl.create(:premium_schedule, loan: loan1, calc_type: 'S')
    FactoryGirl.create(:premium_schedule, loan: loan2, calc_type: 'S')
  end

  it 'works' do
    visit root_path
    click_link 'Extract Premium Schedule Information'

    click_button 'Submit'
    expect(page).to have_selector('.errors-on-base')

    fill_in 'start_on', '1/1/11'
    choose_radio_button 'schedule_type', 'new'
    click_button 'Submit'

    expect(page).to have_content('Data extract found 2 rows')
    click_button 'Download'
    expect(page.response_headers['Content-Type']).to include('text/csv')
  end

  private
    def choose_radio_button(attribute, value)
      choose "premium_schedule_report_#{attribute}_#{value}"
    end

    def fill_in(attribute, value)
      page.fill_in "premium_schedule_report_#{attribute}", with: value
    end
end
