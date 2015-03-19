require 'rails_helper'

describe 'loan audit log' do
  let(:current_user) { FactoryGirl.create(:lender_user) }

  let(:another_user) { FactoryGirl.create(:lender_user) }

  let!(:loan) {
    loan = FactoryGirl.create(:loan, :guaranteed, lender: current_user.lender)
    FactoryGirl.create(:accepted_loan_state_change, loan: loan, modified_by: current_user)
    FactoryGirl.create(:completed_loan_state_change, loan: loan, modified_by: another_user)
    FactoryGirl.create(:offered_loan_state_change, loan: loan, modified_by: current_user)
    FactoryGirl.create(:guaranteed_loan_state_change, loan: loan, modified_by: another_user)

    loan
  }

  before { login_as(current_user, scope: :user) }

  it 'should display all state changes for a loan' do
    visit loan_path(loan)
    click_link "View Audit Log"

    within "#loan_state_change0" do
      expect(page).to have_content('Check Eligibility')
      expect(page).to have_content(current_user.name)
    end

    within "#loan_state_change1" do
      expect(page).to have_content(LoanEvent::Complete.name)
      expect(page).to have_content(another_user.name)
    end

    within "#loan_state_change2" do
      expect(page).to have_content(LoanEvent::OfferSchemeFacility.name)
      expect(page).to have_content(current_user.name)
    end

    within "#loan_state_change3" do
      expect(page).to have_content(LoanEvent::Guaranteed.name)
      expect(page).to have_content(another_user.name)
    end
  end

end
