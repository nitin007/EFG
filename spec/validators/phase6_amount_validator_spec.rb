# encoding: utf-8
require 'spec_helper'

describe Phase6AmountValidator do
  let(:loan) { FactoryGirl.build(:loan) }
  let(:repayment_duration) { MonthDuration.new(12) }
  let(:object) { double(amount: amount, repayment_duration: repayment_duration) }
  let(:validator) { Phase6AmountValidator.new(object, errors) }

  subject(:errors) { ActiveModel::Errors.new(loan) }

  before do
    validator.validate
  end

  context 'when amount is blank' do
    let(:amount) { '' }

    it { should_not be_empty }
  end

  context 'when amount is less than £1,000' do
    let(:amount) { Money.new(999_99) }

    it { should_not be_empty }
  end

  context 'when amount is greater than £1,200,000' do
    let(:amount) { Money.new(1_200_000_01) }

    it { should_not be_empty }
  end

  context 'when amount is greater than £600,000 and repayment duration is longer than 5 years' do
    let(:amount) { Money.new(600_000_01) }
    let(:repayment_duration) { MonthDuration.new(61) }

    it { should_not be_empty }
  end

end
