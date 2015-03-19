require 'spec_helper'

describe 'loan repay' do
  let(:current_user) { FactoryGirl.create(:lender_user) }
  let(:loan) { FactoryGirl.create(:loan, :guaranteed, lender: current_user.lender) }
  before { login_as(current_user, scope: :user) }

  it 'repays a loan' do
    visit loan_path(loan)
    click_link 'Repay Loan'

    fill_in 'repaid_on', 1.day.from_now.to_date.to_s(:screen)
    click_button 'Submit'

    loan = Loan.last

    expect(current_path).to eq(loan_path(loan))

    expect(loan.state).to eq(Loan::Repaid)
    expect(loan.repaid_on).to eq(1.day.from_now.to_date)
    expect(loan.modified_by).to eq(current_user)

    should_log_loan_state_change(loan, Loan::Repaid, 14, current_user)
  end

  it 'repays a LenderDemand loan' do
    loan.update_attribute :state, Loan::LenderDemand
    visit loan_path(loan)
    click_link 'Repay Loan'

    fill_in 'repaid_on', 1.day.from_now.to_date.to_s(:screen)
    click_button 'Submit'

    loan = Loan.last

    expect(current_path).to eq(loan_path(loan))

    expect(loan.state).to eq(Loan::Repaid)
    expect(loan.repaid_on).to eq(1.day.from_now.to_date)
    expect(loan.modified_by).to eq(current_user)
  end

  it 'does not continue with invalid values' do
    visit loan_path(loan)
    click_link 'Repay Loan'

    expect(loan.state).to eq(Loan::Guaranteed)
    expect {
      click_button 'Submit'
      loan.reload
    }.to_not change(loan, :state)

    expect(current_path).to eq(loan_repay_path(loan))
  end

  private
  def fill_in(attribute, value)
    page.fill_in "loan_repay_#{attribute}", with: value
  end
end
