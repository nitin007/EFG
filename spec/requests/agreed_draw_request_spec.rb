require 'spec_helper'

describe 'agreed draw' do
  let(:current_user) { FactoryGirl.create(:lender_user, lender: loan.lender) }
  before { login_as(current_user, scope: :user) }

  let(:loan) { FactoryGirl.create(:loan, :guaranteed, amount: Money.new(100_000_00)) }

  context 'when the loan has drawn its full amount' do
    before do
      FactoryGirl.create(:loan_change, loan: loan, amount_drawn: Money.new(90_000_00), change_type: ChangeType::RecordAgreedDraw)
      visit loan_path(loan)
    end

    it 'does not include the reprofile draws option' do
      page.should_not have_content('Record Agreed Draw')
    end
  end

  context 'when the loan has not drawn its full amount' do
    before do
      visit loan_path(loan)
      click_link 'Record Agreed Draw'
    end

    it do
      fill_in :date_of_change, '1/12/11'
      fill_in :amount_drawn, '12,345.67'
      click_button 'Submit'

      loan_change = loan.loan_changes.last!
      loan_change.change_type.should == ChangeType::RecordAgreedDraw
      loan_change.date_of_change.should == Date.new(2011, 12, 1)
      loan_change.amount_drawn.should == Money.new(12_345_67)

      loan.reload
      loan.modified_by.should == current_user
    end

    it 'does not continue with invalid values' do
      expect {
        click_button 'Submit'
      }.to change(LoanChange, :count).by(0)
    end
  end

  private
    def fill_in(attribute, value)
      page.fill_in "agreed_draw_#{attribute}", with: value
    end
end
