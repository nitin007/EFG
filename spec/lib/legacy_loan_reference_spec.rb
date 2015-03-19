require 'rails_helper'

describe LegacyLoanReference do

  describe "#initialize" do
    it "raises exception when invalid reference" do
      ['1', '12', '123', '1234', '1234567', 'ABC1234+01', '', nil].each do |string|
        expect {
          LegacyLoanReference.new(string)
        }.to raise_error(InvalidLegacyLoanReference), "#{string} should not be a valid legacy loan reference"
      end
    end

    it "does not raise exception when valid reference" do
      %w(12345 123456 12345-02 123456-10).each do |string|
        expect {
          LegacyLoanReference.new(string)
        }.not_to raise_error
      end
    end
  end

  describe "#increment" do
    it "should increment loan reference without initial version number" do
      loan_reference = LegacyLoanReference.new('100009')

      expect(loan_reference.increment).to eq('100009-02')
    end

    it "should return increment loan reference with initial version number" do
      loan_reference = LegacyLoanReference.new('100009-02')

      expect(loan_reference.increment).to eq('100009-03')
    end

    it "should increment loan reference into double digits" do
      loan_reference = LegacyLoanReference.new('100009-09')

      expect(loan_reference.increment).to eq('100009-10')
    end

    it "should not increment loan reference repeatedly" do
      loan_reference = LegacyLoanReference.new('100009')
      incremented_reference = nil

      2.times { incremented_reference = loan_reference.increment }

      expect(incremented_reference).to eq('100009-02')
    end
  end

end