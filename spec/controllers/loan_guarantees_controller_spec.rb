require 'spec_helper'

describe LoanGuaranteesController do
  describe '#new' do
    let(:current_lender) { FactoryGirl.create(:lender) }
    let(:current_user) { FactoryGirl.create(:lender_user, lender: current_lender) }
    before { sign_in(current_user) }

    def dispatch(params)
      get :new, params
    end

    it 'works with a loan from the same lender' do
      loan = FactoryGirl.create(:loan, :offered, lender: current_lender)

      dispatch loan_id: loan.id

      response.should be_success
    end

    it 'raises RecordNotFound for a loan from another lender' do
      other_lender = FactoryGirl.create(:lender)
      loan = FactoryGirl.create(:loan, :offered, lender: other_lender)

      expect {
        dispatch loan_id: loan.id
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#create' do
    let(:current_lender) { FactoryGirl.create(:lender) }
    let(:current_user) { FactoryGirl.create(:lender_user, lender: current_lender) }
    before { sign_in(current_user) }

    let(:loan_guarantee) { double(LoanGuarantee, loan: loan, :attributes= => false, save: false) }
    before { LoanGuarantee.stub!(:new).and_return(loan_guarantee) }

    def dispatch(parameters = {})
      default_parameters = {loan_id: loan.id, loan_guarantee: {}}
      post :create, default_parameters.merge(parameters)
    end

    context "with a loan from the current lender" do
      let(:loan) { FactoryGirl.create(:loan, :offered, lender: current_lender) }

      context "with a valid Loan Guarantee" do
        before { loan_guarantee.stub!(:save).and_return(true) }

        it "should redirect to loan show" do
          dispatch
          response.should redirect_to(loan_url(loan))
        end
      end

      context "with an invalid Loan Guarantee" do
        before { loan_guarantee.stub!(:save).and_return(false) }

        it "should render new" do
          dispatch
          response.should render_template(:new)
        end
      end
    end

    context "with another lender's loan" do
      let(:other_lender) { FactoryGirl.create(:lender) }
      let(:loan) { FactoryGirl.create(:loan, :offered, lender: other_lender) }

      it 'raises RecordNotFound for a loan from another lender' do
        expect {
          dispatch
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
