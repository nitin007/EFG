require 'spec_helper'

describe TransferredLoanEntriesController do
  let(:loan) { FactoryGirl.create(:loan, :incomplete, :transferred) }

  describe '#new' do
    def dispatch(params = {})
      get :new, { loan_id: loan.id }.merge(params)
    end

    it_behaves_like 'CfeUser-restricted LoanPresenter controller'
    it_behaves_like 'LenderUser-restricted LoanPresenter controller'

    context 'as a LenderUser from the same lender' do
      let(:current_user) { FactoryGirl.create(:lender_user, lender: loan.lender) }
      before { sign_in(current_user) }

      it do
        dispatch
        response.should be_success
      end
    end
  end

  describe '#create' do
    def dispatch(params = {})
      post :create, { loan_id: loan.id, transferred_loan_entry: {} }.merge(params)
    end

    it_behaves_like 'CfeUser-restricted LoanPresenter controller'
    it_behaves_like 'LenderUser-restricted LoanPresenter controller'

    context 'as a LenderUser from the same lender' do
      let(:current_user) { FactoryGirl.create(:lender_user, lender: loan.lender) }
      before { sign_in(current_user) }
      let(:transferred_loan_entry) { double(TransferredLoanEntry, loan: loan, :attributes= => nil)}
      before { TransferredLoanEntry.stub!(:new).and_return(transferred_loan_entry) }

      context "when submitting a valid loan" do
        before { transferred_loan_entry.stub!(:save).and_return(true) }

        def dispatch(parameters = {})
          super(commit: 'Submit')
        end

        it "should redirect to the loan page" do
          dispatch
          response.should redirect_to(loan_url(loan))
        end
      end

      context "when submitting an invalid loan" do
        before { transferred_loan_entry.stub!(:save).and_return(false) }

        def dispatch(parameters = {})
          super(commit: 'Submit')
        end

        it "should render new action" do
          dispatch
          response.should render_template(:new)
        end
      end
    end
  end
end
