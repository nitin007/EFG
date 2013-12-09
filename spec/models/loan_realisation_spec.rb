require 'spec_helper'

describe LoanRealisation do
  describe 'validations' do
    let(:loan_realisation) { FactoryGirl.build(:loan_realisation) }

    it 'should have a valid factory' do
      loan_realisation.should be_valid
    end

    it 'strictly requires a realised loan' do
      expect {
        loan_realisation.realised_loan = nil
        loan_realisation.valid?
      }.to raise_error(ActiveModel::StrictValidationFailed)
    end

    it 'must have a realisation statement' do
      loan_realisation.realisation_statement = nil
      loan_realisation.should_not be_valid
    end

    it 'strictly requires a created by user' do
      expect {
        loan_realisation.created_by = nil
        loan_realisation.valid?
      }.to raise_error(ActiveModel::StrictValidationFailed)
    end

    it 'strictly requires a realised amount' do
      expect {
        loan_realisation.realised_amount = nil
        loan_realisation.valid?
      }.to raise_error(ActiveModel::StrictValidationFailed)
    end

    it 'strictly requires a realised_on' do
      expect {
        loan_realisation.realised_on = nil
        loan_realisation.valid?
      }.to raise_error(ActiveModel::StrictValidationFailed)
    end
  end
end
