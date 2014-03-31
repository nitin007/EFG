require 'spec_helper'

describe ClaimLimitsReportsController do

  describe "GET show" do
    def dispatch
      get :show, format: :csv
    end

    it_behaves_like 'AuditorUser-restricted controller'
    it_behaves_like 'CfeAdmin-restricted controller'
    it_behaves_like 'LenderAdmin-restricted controller'
    it_behaves_like 'LenderUser-restricted controller'
    it_behaves_like 'PremiumCollectorUser-restricted controller'

    context 'when Cfe User' do
      let(:current_user) { FactoryGirl.create(:cfe_user) }

      before do
        sign_in(current_user)
        dispatch
      end

      it "renders CSV loan data" do
        response.content_type.should == 'text/csv'
      end

      it "sets filename for CSV" do
        expected_filename = "lender_claim_limits_#{Date.current.strftime('%Y-%m-%d')}.csv"
        response.headers['Content-Disposition'].should include(%Q(filename="#{expected_filename}"))
      end
    end
  end

end
