require 'spec_helper'

describe LoanStatesController do
  let(:loan) { FactoryGirl.create(:loan, :guaranteed) }

  describe '#show' do
    def dispatch(params = {})
      get :show, { id: 'guaranteed' }.merge(params)
    end

    it_behaves_like 'CfeAdmin-restricted controller'
    it_behaves_like 'LenderAdmin-restricted controller'
    it_behaves_like 'PremiumCollectorUser-restricted controller'

    context 'when requesting CSV export' do
      let(:current_user) { FactoryGirl.create(:lender_user, lender: loan.lender) }

      before do
        sign_in(current_user)
        dispatch(format: 'csv')
      end

      it "renders CSV loan data" do
        expect(response.content_type).to eq('text/csv')
      end

      it "sets filename for CSV" do
        expected_filename = "#{loan.state}_loans_#{Date.current.strftime('%Y-%m-%d')}.csv"
        expect(response.headers['Content-Disposition']).to include(%Q(filename="#{expected_filename}"))
      end
    end
  end
end
