require 'spec_helper'
require 'csv'

describe ClaimLimitsCsvExport do

  let(:lender) { FactoryGirl.build(:lender, name: 'Little Tinkers') }

  let(:claim_limit_calculator) { Phase1ClaimLimitCalculator.new(lender) }

  let(:claim_limits_csv_export) { ClaimLimitsCsvExport.new([ claim_limit_calculator ]) }

  before do
    claim_limit_calculator.stub(
      amount_remaining: Money.new(50_000_00),
      cumulative_drawn_amount: Money.new(150_000_00),
      pre_claim_realisations_amount: Money.new(1_000_00),
      settled_amount: Money.new(49_000_00),
      total_amount: Money.new(100_000_00)
    )
  end

  describe ".header" do
    let(:header) { CSV.parse(claim_limits_csv_export.first).first }

    it "should return array of strings with correct text" do
      header[0].should == t(:lender_name)
      header[1].should == t(:phase)
      header[2].should == t(:claim_limit)
      header[3].should == t(:cumulative_drawn_amount)
      header[4].should == t(:settled)
      header[5].should == t(:pre_claim_limit_realisations)
      header[6].should == t(:claim_limit_remaining)
    end
  end

  describe "#generate" do
    let(:parsed_csv) { CSV.parse(claim_limits_csv_export.generate) }

    let(:row) { parsed_csv[1] }

    it "should return a row for the header and each claim limit" do
      parsed_csv.size.should == 2
    end

    it "includes lender name" do
      row[0].should == 'Little Tinkers'
    end

    it "includes phase name" do
      row[1].should == 'Phase 1'
    end

    it "includes claim limit amount" do
      row[2].should == Money.new(100_000_00).to_s
    end

    it "includes cumulative drawn amount" do
      row[3].should == Money.new(150_000_00).to_s
    end

    it "includes settled amount" do
      row[4].should == Money.new(49_000_00).to_s
    end

    it "includes pre-claim limit realisations amount" do
      row[5].should == Money.new(1_000_00).to_s
    end

    it "includes claim limit remaining" do
      row[6].should == Money.new(50_000_00).to_s
    end
  end

  private

  def t(key)
    I18n.t(key, scope: 'csv_headers.claim_limits_report')
  end

end
