require 'rails_helper'

describe DocumentsController do
  let(:loan) { FactoryGirl.create(:loan, :completed) }
  let(:current_user) { FactoryGirl.create(:lender_user, lender: loan.lender) }
  before { sign_in(current_user) }

  describe '#state_aid_letter' do
    def dispatch
      get :state_aid_letter, id: loan.id
    end

    it_behaves_like 'documents controller action'
    it_behaves_like 'AuditorUser-restricted controller'
    it_behaves_like 'CfeAdmin-restricted controller'
    it_behaves_like 'CfeUser-restricted controller'
    it_behaves_like 'LenderAdmin-restricted controller'
    it_behaves_like 'LenderUser Lender-scoped controller'
    it_behaves_like 'PremiumCollectorUser-restricted controller'
  end

  describe '#information_declaration' do
    def dispatch
      get :information_declaration, id: loan.id
    end

    it_behaves_like 'documents controller action'
    it_behaves_like 'AuditorUser-restricted controller'
    it_behaves_like 'CfeAdmin-restricted controller'
    it_behaves_like 'CfeUser-restricted controller'
    it_behaves_like 'LenderAdmin-restricted controller'
    it_behaves_like 'LenderUser Lender-scoped controller'
    it_behaves_like 'PremiumCollectorUser-restricted controller'
  end

  describe '#data_protection_declaration' do
    def dispatch
      get :data_protection_declaration, id: loan.id
    end

    it_behaves_like 'AuditorUser-restricted controller'
    it_behaves_like 'CfeAdmin-restricted controller'
    it_behaves_like 'CfeUser-restricted controller'
    it_behaves_like 'LenderAdmin-restricted controller'
    it_behaves_like 'PremiumCollectorUser-restricted controller'

    it 'renders PDF document' do
      dispatch

      expect(response.content_type).to eq('application/pdf')
    end
  end
end
