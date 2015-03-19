require 'spec_helper'

describe Invoice do
  describe "validations" do
    let(:invoice) { FactoryGirl.build(:invoice) }

    it "should have a valid factory" do
      expect(invoice).to be_valid
    end

    it "must have a lender" do
      expect {
        invoice.lender = nil
        invoice.valid?
      }.to raise_error(ActiveModel::StrictValidationFailed)
    end

    it "must have a reference" do
      expect {
        invoice.reference = ''
        invoice.valid?
      }.to raise_error(ActiveModel::StrictValidationFailed)
    end

    it "must have a period covered quarter" do
      expect {
        invoice.period_covered_quarter = ''
        invoice.valid?
      }.to raise_error(ActiveModel::StrictValidationFailed)
    end

    it "must have a valid period covered quarter" do
      expect {
        invoice.period_covered_quarter = 'August'
        invoice.valid?
      }.to raise_error(ActiveModel::StrictValidationFailed)
    end

    it "must have a period covered year" do
      expect {
        invoice.period_covered_year = ''
        invoice.valid?
      }.to raise_error(ActiveModel::StrictValidationFailed)
    end

    it "must have a valid period covered year" do
      expect {
        invoice.period_covered_year = '01'
        invoice.valid?
      }.to raise_error(ActiveModel::StrictValidationFailed)
    end

    it "must have a received on date" do
      expect {
        invoice.received_on = ''
        invoice.valid?
      }.to raise_error(ActiveModel::StrictValidationFailed)
    end

    it "must have a valid received on date" do
      expect {
        invoice.received_on = nil
        invoice.valid?
      }.to raise_error(ActiveModel::StrictValidationFailed)
    end

    it "must have a creator" do
      expect {
        invoice.created_by = nil
        invoice.valid?
      }.to raise_error(ActiveModel::StrictValidationFailed)
    end
  end

  describe "#xref" do
    let(:invoice) { FactoryGirl.build(:invoice) }

    it "should be set on creation" do
      expect(invoice.xref).to be_blank
      invoice.save!
      expect(invoice.xref).not_to be_blank
    end

    it "should be unique" do
      invoice.save!

      another_invoice = FactoryGirl.build(:invoice)
      allow(another_invoice).to receive(:random_xref).and_return(invoice.xref, '789012-INV')

      another_invoice.save!
      expect(another_invoice.xref).to eq('789012-INV')
    end

    it "should have 6 random numbers followed by '-INV'" do
      invoice.save!
      expect(invoice.xref).to match(/\d{6}-INV/)
    end
  end
end
