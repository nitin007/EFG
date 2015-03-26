require 'spec_helper'

describe ReprofileDrawsLoanChange do
  it_behaves_like 'LoanChangePresenter'

  describe '#initialize' do
    let(:loan) { FactoryGirl.create(:loan, :guaranteed) }
    let(:presenter) { FactoryGirl.build(:reprofile_draws_loan_change, loan: loan) }

    context 'when the full amount has been drawn' do
      before do
        loan.initial_draw_change.update_column(:amount_drawn, loan.amount.cents)
      end

      it 'is not allowed' do
        expect {
          presenter
        }.to raise_error(ReprofileDrawsLoanChange::LoanAlreadyFullyDrawnError)
      end
    end
  end

  describe "validations" do
    context "valid factory" do
      subject { FactoryGirl.build(:reprofile_draws_loan_change) }
      it { should be_valid }
    end

    context "with draw amounts" do
      let(:draw_change) {
        FactoryGirl.build(:reprofile_draws_loan_change,
          second_draw_amount: Money.new(100_00), second_draw_months: 6,
          third_draw_amount: Money.new(100_00), third_draw_months: 6,
          fourth_draw_amount: Money.new(100_00), fourth_draw_months: 6)
      }

      specify { draw_change.should be_valid }

      it 'every draw amount needs a draw month' do
        draw_change.fourth_draw_months = ''
        expect(draw_change).not_to be_valid
        draw_change.fourth_draw_months = 1

        draw_change.third_draw_months = ''
        expect(draw_change).not_to be_valid
        draw_change.third_draw_months = 2

        draw_change.second_draw_months = ''
        expect(draw_change).not_to be_valid
        draw_change.second_draw_months = 3

        expect(draw_change).to be_valid
      end

      it 'second draw must not be skipped if third or fourth is present' do
        draw_change.second_draw_amount = ''
        expect(draw_change).not_to be_valid

        draw_change.fourth_draw_amount = ''
        expect(draw_change).not_to be_valid

        draw_change.third_draw_amount = ''
        draw_change.fourth_draw_amount = Money.new(100_00)
        expect(draw_change).not_to be_valid

        draw_change.third_draw_amount = ''
        draw_change.fourth_draw_amount = ''
        expect(draw_change).to be_valid
      end

      it 'third draw must not be skipped if fourth is present' do
        draw_change.third_draw_amount = ''
        expect(draw_change).not_to be_valid

        draw_change.fourth_draw_amount = ''
        expect(draw_change).to be_valid
      end
    end
  end

  describe '#save' do
    let(:user) { FactoryGirl.create(:lender_user) }
    let(:loan) { FactoryGirl.create(:loan, :guaranteed, :with_premium_schedule, repayment_duration: 60) }
    let(:presenter) { FactoryGirl.build(:reprofile_draws_loan_change, created_by: user, loan: loan) }

    before do
      loan.initial_draw_change.update_column :date_of_change, Date.new(2010, 1)
    end

    it 'creates a LoanChange, a PremiumSchedule, and updates the loan' do
      Timecop.freeze(2013, 3, 1) do
        presenter.save.should == true
      end

      loan_change = loan.loan_changes.last!
      loan_change.change_type.should == ChangeType::ReprofileDraws
      loan_change.created_by.should == user

      loan.reload
      loan.modified_by.should == user

      premium_schedule = loan.premium_schedules.last!
      premium_schedule.premium_cheque_month.should == '04/2013'
      premium_schedule.repayment_duration.should == 21
    end
  end
end
