require 'spec_helper'

describe 'loan states' do
  describe '#index' do
    let(:current_lender) { FactoryGirl.create(:lender) }
    let(:current_user) { FactoryGirl.create(:lender_user, lender: current_lender) }

    before do
      login_as(current_user, scope: :user)
      FactoryGirl.create(:loan, :legacy_sflg, lender: current_lender)
      FactoryGirl.create(:loan, :sflg, :offered, lender: current_lender)
      FactoryGirl.create(:loan, :guaranteed, lender: current_lender)
    end

    def dispatch
      visit loan_states_path
    end

    def counts(state)
      page.all("tbody tr##{state}_loans td").map { |cell| cell.text.strip }
    end

    it 'lists loan states and the number of loans by scheme' do
      dispatch

      {
        'eligible'    => { legacy_sflg: "1", sflg: "0", efg: "0", total: "1" },
        'offered'     => { legacy_sflg: "0", sflg: "1", efg: "0", total: "1" },
        'guaranteed'  => { legacy_sflg: "0", sflg: "0", efg: "1", total: "1" }
      }.each do |state, expected_counts|
        expect(counts(state)).to eq(expected_counts.values)
      end
    end

    it 'does not include loans from another lender' do
      FactoryGirl.create(:loan, :completed)
      FactoryGirl.create(:loan, :offered)

      dispatch

      {
        'eligible'    => { legacy_sflg: "1", sflg: "0", efg: "0", total: "1" },
        'offered'     => { legacy_sflg: "0", sflg: "1", efg: "0", total: "1" },
        'guaranteed'  => { legacy_sflg: "0", sflg: "0", efg: "1", total: "1" }
      }.each do |state, expected_counts|
        expect(counts(state)).to eq(expected_counts.values)
      end
    end
  end

  describe '#show' do
    let(:current_lender) { FactoryGirl.create(:lender) }
    let(:current_user) { FactoryGirl.create(:lender_user, lender: current_lender) }

    before do
      login_as(current_user, scope: :user)
      FactoryGirl.create(:loan, :completed, lender: current_lender, business_name: 'ACME')
      FactoryGirl.create(:loan, :completed, lender: current_lender, business_name: 'Foo')
    end

    def dispatch(params)
      visit loan_state_path(params)
    end

    it 'includes loans in the specified state' do
      dispatch(id: 'completed')

      names = page.all('tbody tr td:nth-child(2)').map(&:text)
      expect(names).to eq(%w(ACME Foo))
    end

    it 'does not include loans from other states' do
      FactoryGirl.create(:loan, :offered, lender: current_lender, business_name: 'Bar')

      dispatch(id: 'completed')

      names = page.all('tbody tr td:nth-child(2)').map(&:text)
      expect(names).not_to include('Bar')
    end

    it 'does not include loans from another lender' do
      FactoryGirl.create(:loan, :completed, business_name: 'Baz')

      dispatch(id: 'completed')

      names = page.all('tbody tr td:nth-child(2)').map(&:text)
      expect(names).not_to include('Baz')
    end

    it "filters loans by scheme" do
      FactoryGirl.create(:loan, :completed, :legacy_sflg, lender: current_lender, business_name: 'Bar')
      FactoryGirl.create(:loan, :completed, :sflg, lender: current_lender, business_name: 'Woot')

      dispatch(id: 'completed', scheme: 'efg')

      names = page.all('tbody tr td:nth-child(2)').map(&:text)
      expect(names).to include('ACME')
      expect(names).to include('Foo')
      expect(names).not_to include('Bar')
      expect(names).not_to include('Woot')
    end

    it 'can export loan data as CSV' do
      dispatch(id: 'completed')

      click_link "Export CSV"

      expect(page.current_url).to eq(loan_state_url(id: 'completed', format: 'csv'))
    end

    it 'exports loan data as a CSV with a scheme filter' do
      dispatch(id: 'completed', scheme: 'efg')

      click_link "Export CSV"

      expect(page.current_url).to eq(loan_state_url(id: 'completed', format: 'csv', scheme: 'efg'))
    end
  end
end
