require 'spec_helper'

describe LoanRealisationAdjustment do
  describe 'validations:' do
    let(:amount) { '100.00' }
    let(:attributes) {
      {
        'amount' => amount,
        'date' => date,
        'notes' => notes
      }
    }
    let(:date) { '1/1/11' }
    let(:loan) { FactoryGirl.create(:loan, :realised) }
    let(:notes) { 'notes' }

    subject { LoanRealisationAdjustment.new(loan, attributes) }

    context 'with valid attributes' do
      it { should be_valid }
    end

    context '#amount' do
      context 'when blank' do
        let(:amount) { '' }
        it { should_not be_valid }
      end

      context 'when negative' do
        let(:amount) { '-1' }
        it { should_not be_valid }
      end

      context 'when zero' do
        let(:amount) { '0' }
        it { should_not be_valid }
      end
    end

    context '#date' do
      context 'when blank' do
        let(:date) { '' }
        it { should_not be_valid }
      end
    end
  end
end
