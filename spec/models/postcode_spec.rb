require 'spec_helper'

describe Postcode do
  describe '#==' do
    let(:postcode) { Postcode.new('EC1R 4RP') }
    subject { postcode == other }

    context 'a Postcode with the same value' do
      let(:other) { Postcode.new('EC1R 4RP') }
      it { should be_true }
    end

    context 'a Postcode with the same but differently formatted value' do
      let(:other) { Postcode.new('ec1r4rp') }
      it { should be_true }
    end

    context 'a String with the same value' do
      let(:other) { 'EC1R 4RP' }
      it { should be_true }
    end

    context 'a Postcode with a different value' do
      let(:other) { Postcode.new('SW1A 1AA') }
      it { should be_false }
    end

    context 'a String with a different value' do
      let(:other) { 'SW1A 1AA' }
      it { should be_false }
    end
  end

  describe '#to_s' do
    let(:postcode) { Postcode.new(string) }
    subject { postcode.to_s }

    context 'correctly formatted' do
      let(:string) { 'EC1R 4RP' }
      it { should == 'EC1R 4RP' }
    end

    context 'lower case' do
      let(:string) { 'ec1r 4rp' }
      it { should == 'EC1R 4RP' }
    end

    context 'no space' do
      let(:string) { 'EC1R4RP' }
      it { should == 'EC1R 4RP' }
    end

    context 'transposed' do
      let(:string) { 'ECIR 4RP' }
      it { should == 'EC1R 4RP' }
    end

    context 'invalid' do
      let(:string) { 'invalid' }
      it { should == 'invalid' }
    end
  end
end
