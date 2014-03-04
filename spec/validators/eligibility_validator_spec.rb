# encoding: utf-8
require 'spec_helper'

describe EligibilityValidator do
  describe "eligibility checks" do
    let(:loan) { FactoryGirl.build(:loan) }
    let(:errors) { ActiveModel::Errors.new(loan) }
    let(:validator) { EligibilityValidator.new(loan, errors: errors) }

    it 'should start with a valid (eligible) loan' do
      validator.validate
      errors.should be_empty
    end

    it "should be ineligible when it's not a viable proposition" do
      loan.viable_proposition = false

      validator.validate
      errors[:viable_proposition].should_not be_empty
    end

    it "should be ineligible when the lender doesn't wish to lend" do
      loan.would_you_lend = false

      validator.validate
      errors[:would_you_lend].should_not be_empty
    end

    it "should be ineligible if collateral isn't exhausted" do
      loan.collateral_exhausted = false

      validator.validate
      errors[:collateral_exhausted].should_not be_empty
    end

    it "should be ineligible if a private residence charge is required" do
      loan.private_residence_charge_required = true

      validator.validate
      errors[:private_residence_charge_required].should_not be_empty
    end

    it "should be ineligible if the amount is less than £1000" do
      loan.amount = Money.new(99999) # £999.99

      validator.validate
      errors[:amount].should_not be_empty
    end

    it "should be ineligible if the amount is greater than £1,000,000" do
      loan.amount = Money.new(100000001) # £1,000,000.01

      validator.validate
      errors[:amount].should_not be_empty
    end

    it "should be ineligible if the repayment duration is less than 3 months" do
      loan.repayment_duration = {months: 2}

      validator.validate
      errors[:repayment_duration].should_not be_empty
    end

    it "should be ineligible if the repayment duration is longer than 10 years" do
      loan.repayment_duration = {years: 10, months: 1}

      validator.validate
      errors[:repayment_duration].should_not be_empty
    end

    context 'Type E' do
      before do
        loan.lending_limit = lending_limit
        loan.loan_category_id = 5
        loan.repayment_duration = repayment_duration
      end

      context 'phase 5' do
        let(:lending_limit) { FactoryGirl.create(:lending_limit, :phase_5) }

        context 'when the repayment duration is 2 years or shorter' do
          let(:repayment_duration) { {years: 2, months: 0} }

          it 'is eligible' do
            validator.validate
            errors.should be_empty
          end
        end

        context 'when the repayment duration is longer than 2 years' do
          let(:repayment_duration) { {years: 2, months: 1} }

          it 'is ineligible' do
            validator.validate
            errors[:repayment_duration].should_not be_empty
          end
        end
      end

      context 'phase 6' do
        let(:lending_limit) { FactoryGirl.create(:lending_limit, :phase_6) }

        context 'when the repayment duration is 3 years or shorter' do
          let(:repayment_duration) { {years: 3, months: 0} }

          it 'is eligible' do
            validator.validate
            errors.should be_empty
          end
        end

        context 'when the repayment duration is longer than 3 years' do
          let(:repayment_duration) { {years: 3, months: 1} }

          it 'is ineligible' do
            validator.validate
            errors[:repayment_duration].should_not be_empty
          end
        end
      end
    end

    it "should be ineligible if the loan is a Type F facility and repayment duration is longer than 3 years" do
      loan.loan_category_id = 6 # Type F facility
      loan.repayment_duration = {years: 3, months: 1}

      validator.validate
      errors[:repayment_duration].should_not be_empty
    end

    it "should be ineligible if the loan trading date is more than 6 months in the future" do
      loan.trading_date = 6.months.from_now.advance(days: 1)

      validator.validate
      errors[:trading_date].should_not be_empty
    end

    it "should be ineligible if previous borrowing + this amount is not greater than £1,000,000" do
      loan.previous_borrowing = false

      validator.validate
      errors[:previous_borrowing].should_not be_empty
    end

    it "should be ineligible when SIC code is ineligible" do
      loan.sic_eligible = false

      validator.validate
      errors[:sic_code].should_not be_empty
    end

    it "should be ineligible with an ineligible loan reason" do
      loan.reason_id = LoanReason.all.detect {|reason| !reason.eligible? }.id

      validator.validate
      errors[:reason_id].should_not be_empty
    end
  end
end
