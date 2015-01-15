# encoding: utf-8

require 'spec_helper'

describe DataCorrection do
  it_behaves_like 'LoanModification'

  describe '#seq' do
    let(:loan) { FactoryGirl.create(:loan, :guaranteed) }

    it 'is incremented for each DataCorrection' do
      correction1 = FactoryGirl.create(:data_correction, loan: loan)
      correction2 = FactoryGirl.create(:data_correction, loan: loan)

      correction1.seq.should == 1
      correction2.seq.should == 2
    end
  end

  describe "#changes" do
    let(:loan) { FactoryGirl.create(:loan, :guaranteed) }

    describe "data correction with postcode change" do
      let(:data_correction_changes) { { postcode: [loan.postcode.to_s, 'E15 1LU'] } }
      let(:data_correction) {
        FactoryGirl.create(:data_correction,
          loan: loan,
          data_correction_changes: data_correction_changes)
      }

      it "should return the old and new postcodes" do
        data_correction.changes.should == [{
          old_attribute: 'old_postcode',
          old_value: loan.postcode,
          attribute: 'postcode',
          value: 'E15 1LU',
        }]
      end
    end

    describe "data correction with lending limit change" do
      let(:lender) { loan.lender }
      let(:lending_limit_1) { FactoryGirl.create(:lending_limit, lender: lender) }
      let(:lending_limit_2) { FactoryGirl.create(:lending_limit, lender: lender) }
      let(:data_correction_changes) {
        { lending_limit_id: [lending_limit_1.id, lending_limit_2.id] }
      }
      let(:data_correction) {
        FactoryGirl.create(:data_correction,
          loan: loan,
          data_correction_changes: data_correction_changes)
      }

      it "should return the old and new lending limits" do
        data_correction.changes.should == [{
          old_attribute: 'old_lending_limit',
          old_value: lending_limit_1,
          attribute: 'lending_limit',
          value: lending_limit_2
        }]
      end
    end
  end
end
