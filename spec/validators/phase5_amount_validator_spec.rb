# encoding: utf-8
require 'spec_helper'

describe Phase5AmountValidator do
  let(:loan) { FactoryGirl.build(:loan) }
  let(:object) { double(amount: amount) }
  let(:validator) { Phase5AmountValidator.new(object, errors) }

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

  context 'when amount is greater than £1,000,000' do
    let(:amount) { Money.new(1_000_000_01) }

    it { should_not be_empty }
  end

end
