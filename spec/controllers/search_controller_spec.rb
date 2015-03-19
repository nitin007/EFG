require 'rails_helper'

describe SearchController do
  let(:current_lender) { FactoryGirl.create(:lender) }
  let(:current_user) { FactoryGirl.create(:lender_user, lender: current_lender) }
  let!(:loan) { FactoryGirl.create(:loan, reference: "ABC123", lender: current_lender)}
  before { sign_in(current_user) }

  describe '#lookup' do
    def dispatch(params = {})
      get :lookup, params
    end

    it_behaves_like 'CfeAdmin-restricted controller'
    it_behaves_like 'LenderAdmin-restricted controller'
    it_behaves_like 'PremiumCollectorUser-restricted controller'

    it 'assigns loans for the current lender' do
      dispatch(reference: loan.reference)

      expect(assigns[:results]).to include(loan)
    end

    it 'does not return loans from another lender' do
      other_lender      = FactoryGirl.create(:lender)
      other_lender_loan = FactoryGirl.create(:loan, reference: "ABC12345", lender: other_lender)

      dispatch reference: "ABC"
      expect(assigns[:results]).not_to include(other_lender_loan)
    end
  end
end
