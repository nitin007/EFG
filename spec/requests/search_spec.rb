require 'rails_helper'

describe "search" do
  let(:current_lender) { FactoryGirl.create(:lender) }
  let(:current_user) { FactoryGirl.create(:lender_user, lender: current_lender) }
  let!(:loan1) {
    FactoryGirl.create(:loan, :guaranteed,
                       reference: "9BCI17R-01",
                       lender: current_lender,
                       lender_reference: 'lenderref01')
  }
  let!(:loan2) { FactoryGirl.create(:loan, :offered, reference: "9BCI17R-02", lender: current_lender, business_name: "Inter-slice") }

  before do
    login_as(current_user, scope: :user)
  end

  it "should find a specific loan" do
    visit new_search_path

    within "#search" do
      fill_in 'search[business_name]', with: loan1.business_name
      fill_in 'search[trading_name]', with: loan1.trading_name
      fill_in 'search[company_registration]', with: loan1.company_registration
      fill_in 'search[lender_reference]', with: loan1.lender_reference
      select "Guaranteed", from: 'search[state][]'
      click_button "Search"
    end

    expect(page).to have_content("1 result found")
    expect(page).to have_content(loan1.reference)
    expect(page).not_to have_content(loan2.reference)
  end

  it "should find multiple loans" do
    visit new_search_path

    within "#search" do
      select "Guaranteed", from: 'search[state][]'
      select "Offered", from: 'search[state][]'
      click_button "Search"
    end

    expect(page).to have_content("2 results found")
    expect(page).to have_content(loan1.reference)
    expect(page).to have_content(loan2.reference)
  end

  %w(auditor_user cfe_user).each do |user_type|
    context "as a #{user_type.humanize}" do
      let(:current_user) { FactoryGirl.create(user_type) }

      let!(:another_lender) { FactoryGirl.create(:lender, name: 'Boris Bank') }

      let!(:loan3) { FactoryGirl.create(:loan, lender: another_lender) }

      it 'should allow searching by a specific lender' do
        visit new_search_path

        within "#search" do
          select "Boris Bank", from: 'search[lender_id]'
          click_button "Search"
        end

        expect(page).to have_content("1 result found")
        expect(page).to have_content(loan3.reference)
      end

      it 'should allow searching by all lenders' do
        visit new_search_path

        within "#search" do
          click_button "Search"
        end

        expect(page).to have_content("3 results found")
        expect(page).to have_content(loan1.reference)
        expect(page).to have_content(loan2.reference)
        expect(page).to have_content(loan3.reference)
      end
    end
  end

  %w(cfe_admin premium_collector_user super_user).each do |user_type|
    context "as a #{user_type}" do
      let(:current_user) { FactoryGirl.create(user_type) }

      it 'should not allow searching' do
        expect {
          visit new_search_path
        }.to raise_error(Canable::Transgression)
      end
    end
  end

end
