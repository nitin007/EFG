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

  end
end
