module DataCorrectionSpecHelper
  extend ActiveSupport::Concern

  included do
    let(:current_user) { FactoryGirl.create(:lender_user) }
    before { login_as(current_user, scope: :user) }
  end

  private
    def visit_data_corrections
      visit loan_path(loan)
      click_link 'Data Correction'
    end

    def fill_in(attribute, value)
      page.fill_in "data_correction_#{attribute}", with: value
    end
end
