require 'spec_helper'

describe ClaimLimitCalculator do

  let(:lender) { FactoryGirl.create(:lender) }

  let(:lending_limit) { FactoryGirl.create(:lending_limit, :phase_1, lender: lender) }

  let!(:guaranteed_loan) { FactoryGirl.create(:loan, :guaranteed, lender: lender, lending_limit: lending_limit) }

  let(:calculators) { ClaimLimitCalculator.all_with_amount([ lender ]) }

  describe ".all_with_amount" do
    it "returns array of claim limit calculators, excluding any with 0 amount" do
      calculators.size.should == 1
    end
  end

end
