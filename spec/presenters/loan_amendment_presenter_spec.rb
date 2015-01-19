require 'spec_helper'

describe LoanAmendmentPresenter do

  let(:loan) { FactoryGirl.create(:loan, :guaranteed) }

  let(:params) { { id: amendment.id, type: 'loan_modifications' } }

  subject(:presenter) { LoanAmendmentPresenter.new(loan, params) }

  describe "::for_loan" do
    let(:initial_draw_change) { loan.initial_draw_change }

    let!(:lump_sum_repayment) {
      FactoryGirl.create(:loan_change, :lump_sum_repayment,
        loan: loan, date_of_change: 2.days.from_now
      )
    }

    let!(:data_correction) {
      FactoryGirl.create(:data_correction,
        loan: loan, date_of_change: 1.day.from_now
      )
    }

    let!(:excluded_amendment) { FactoryGirl.create(:loan_change, :lump_sum_repayment) }

    let(:presenters) { LoanAmendmentPresenter.for_loan(loan) }

    it "returns collection of presenters for each amendment" do
      presenters.map(&:amendment).should match_array([initial_draw_change, data_correction, lump_sum_repayment])
    end
  end

  describe "#drawn_amount?" do
    context "with drawn amount" do
      let(:amendment) { loan.initial_draw_change }

      it "returns true" do
        presenter.drawn_amount?.should == true
      end
    end

    context "without drawn amount" do
      let(:amendment) { FactoryGirl.create(:loan_change, loan: loan, amount_drawn: nil) }

      it "returns false" do
        presenter.drawn_amount?.should == false
      end
    end
  end

  describe "#lump_sum_repayment?" do
    context "with lump sum repayment" do
      let(:amendment) { FactoryGirl.create(:loan_change, :lump_sum_repayment, loan: loan) }

      it "returns true" do
        presenter.lump_sum_repayment?.should == true
      end
    end

    context "without lump sum repayment" do
      let(:amendment) { FactoryGirl.create(:loan_change, loan: loan) }

      it "returns false" do
        presenter.lump_sum_repayment?.should == false
      end
    end
  end

end
