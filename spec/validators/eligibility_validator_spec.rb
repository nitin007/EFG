# encoding: utf-8
require 'spec_helper'

describe EligibilityValidator do
  describe "eligibility checks" do
    let(:presenter) { FactoryGirl.build(:loan_eligibility_check) }
    let(:validator) { EligibilityValidator.new(presenter, errors) }

    let(:errors) { ActiveModel::Errors.new(presenter) }

    it 'should start in a valid state' do
      validator.validate
      errors.should be_empty
    end

    it "should be ineligible when it's not a viable proposition" do
      presenter.viable_proposition = false

      validator.validate
      errors[:viable_proposition].should_not be_empty
    end

    it "should be ineligible when the lender doesn't wish to lend" do
      presenter.would_you_lend = false

      validator.validate
      errors[:would_you_lend].should_not be_empty
    end

    it "should be ineligible if collateral isn't exhausted" do
      presenter.collateral_exhausted = false

      validator.validate
      errors[:collateral_exhausted].should_not be_empty
    end

    it "should be ineligible if a private residence charge is required" do
      presenter.private_residence_charge_required = true

      validator.validate
      errors[:private_residence_charge_required].should_not be_empty
    end

    it "should be ineligible if the loan trading date is more than 6 months in the future" do
      presenter.trading_date = 6.months.from_now.advance(days: 1)

      validator.validate
      errors[:trading_date].should_not be_empty
    end

    it "should be ineligible if previous borrowing + this amount is not greater than £1,000,000" do
      presenter.previous_borrowing = false

      validator.validate
      errors[:previous_borrowing].should_not be_empty
    end

    it "should be ineligible when SIC code is ineligible" do
      presenter.sic_code = FactoryGirl.create(:sic_code, :ineligible).code

      validator.validate
      errors[:sic_code].should_not be_empty
    end

    it "should be ineligible with an ineligible loan reason" do
      presenter.reason_id = LoanReason.all.detect {|reason| !reason.eligible? }.id

      validator.validate
      errors[:reason_id].should_not be_empty
    end
  end
end
