require 'spec_helper'

describe Lender do
  describe 'validations' do
    let(:lender) { FactoryGirl.build(:lender) }

    it 'has a valid factory' do
      expect(lender).to be_valid
    end

    it 'requires a name' do
      lender.name = ''
      expect(lender).not_to be_valid
    end

    it 'requires an organisation_reference_code' do
      lender.organisation_reference_code = ''
      expect(lender).not_to be_valid
    end

    it 'requires a unique organisation_reference_code' do
      lender.save!
      new_lender = FactoryGirl.build(:lender, organisation_reference_code: lender.organisation_reference_code)
      expect(new_lender).not_to be_valid
    end

    it 'requires a primary_contact_name' do
      lender.primary_contact_name = ''
      expect(lender).not_to be_valid
    end

    it 'requires a primary_contact_phone' do
      lender.primary_contact_phone = ''
      expect(lender).not_to be_valid
    end

    it 'requires a primary_contact_email' do
      lender.primary_contact_email = ''
      expect(lender).not_to be_valid
    end

    it 'requires can_use_add_cap' do
      lender.can_use_add_cap = ''
      expect(lender).not_to be_valid
    end

    it 'requires the EFG loan_scheme value if not blank' do
      lender.loan_scheme = nil
      expect(lender).to be_valid
      lender.loan_scheme = '!'
      expect(lender).not_to be_valid
      lender.loan_scheme = Lender::EFG_SCHEME
      expect(lender).to be_valid
    end
  end

  describe 'current lending limits' do
    let(:lender) { FactoryGirl.create(:lender) }

    before do
      FactoryGirl.create(:lending_limit, lender: lender, allocation: Money.new(1_000_00), allocation_type_id: LendingLimitType::Annual.id)
      FactoryGirl.create(:lending_limit, lender: lender, allocation: Money.new(2_000_00), allocation_type_id: LendingLimitType::Annual.id, active: false)
      FactoryGirl.create(:lending_limit, lender: lender, allocation: Money.new(4_000_00), allocation_type_id: LendingLimitType::Specific.id)
      FactoryGirl.create(:lending_limit, lender: lender, allocation: Money.new(8_000_00), allocation_type_id: LendingLimitType::Annual.id)
      FactoryGirl.create(:lending_limit, lender: lender, allocation: Money.new(16_000_00), allocation_type_id: LendingLimitType::Annual.id, starts_on: 2.months.ago, ends_on: 1.month.ago)
    end

    it do
      expect(lender.current_annual_lending_limit_allocation).to eq(Money.new(9_000_00))
    end

    it do
      expect(lender.current_specific_lending_limit_allocation).to eq(Money.new(4_000_00))
    end
  end

  describe '#can_access_all_loan_schemes?' do
    it 'should return true when lender has no loan_scheme' do
      lender = FactoryGirl.build(:lender, loan_scheme: nil)
      expect(lender.can_access_all_loan_schemes?).to eq(true)
    end

    it 'should return false when lender has specific loan_scheme' do
      lender = FactoryGirl.build(:lender, loan_scheme: 'E')
      expect(lender.can_access_all_loan_schemes?).to eq(false)
    end
  end

  describe '#logo' do
    subject { FactoryGirl.build(:lender, organisation_reference_code: code) }

    context 'when the lender has an organisation_reference_code' do
      let(:code) { 'XX' }

      its(:logo) { should be_kind_of LenderLogo }
    end

    context 'when the lender does not have an organisation_reference_code' do
      let(:code) { nil }

      its(:logo) { should be_nil }
    end
  end
end
