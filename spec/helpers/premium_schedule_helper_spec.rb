require 'rails_helper'

describe PremiumScheduleHelper do
  describe "premiums_table_rows" do

    context 'when not reschedule' do
      it "with an even number of premiums" do
        premiums = [Money.new(10000), Money.new(70000), Money.new(40000), Money.new(35000)]
        expect(premiums_table_rows(premiums, false).to_a).to eq([
          [[1, Money.new(10000)], [3, Money.new(40000)]],
          [[2, Money.new(70000)], [4, Money.new(35000)]],
        ])
      end

      it "with an odd number of premiums" do
        premiums = [Money.new(10000), Money.new(70000), Money.new(40000)]
        expect(premiums_table_rows(premiums, false).to_a).to eq([
          [[1, Money.new(10000)], [3, Money.new(40000)]],
          [[2, Money.new(70000)], nil],
        ])
      end
    end

    context 'when reschedule' do
      it "should start with an index of 0" do
        premiums = [Money.new(10000), Money.new(70000)]
        expect(premiums_table_rows(premiums, true).to_a).to eq([
          [[0, Money.new(10000)], [1, Money.new(70000)]]
        ])
      end
    end
  end
end
