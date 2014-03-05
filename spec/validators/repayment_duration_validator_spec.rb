require 'spec_helper'

describe RepaymentDurationValidator do
  let(:lending_limit) { FactoryGirl.build(:lending_limit) }
  let(:loan) { FactoryGirl.build(:loan, lending_limit: lending_limit, loan_category_id: loan_category_id) }
  let(:loan_category_id) { 1 }
  let(:object) { double(repayment_duration: repayment_duration, loan: loan) }
  let(:repayment_duration) { MonthDuration.new(total_months) }
  let(:validator) { RepaymentDurationValidator.new(object, errors) }

  subject(:errors) { ActiveModel::Errors.new(loan) }

  before do
    validator.validate
  end

  context 'when there is no repayment_duration' do
    let(:repayment_duration) { '' }

    it { should_not be_empty }
  end

  context 'when the repayment duration is less than 3 months' do
    let(:total_months) { 2 }

    it { should_not be_empty }
  end

  context 'when the repayment duration is longer than 10 years' do
    let(:total_months) { 121 }

    it { should_not be_empty }
  end

  context 'for a Type F loan' do
    let(:loan_category_id) { 6 }

    context 'when the repayment duration is longer than 3 years' do
      let(:total_months) { 37 }

      it { should_not be_empty }
    end
  end

  context 'phase 5' do
    let(:lending_limit) { FactoryGirl.build(:lending_limit, :phase_5) }

    context 'Type E' do
      let(:loan_category_id) { 5 }

      context 'when the repayment duration is 2 years or shorter' do
        let(:total_months) { 24 }

        it { should be_empty }
      end

      context 'when the repayment duration is >= 2 years' do
        let(:total_months) { 25 }

        it { should_not be_empty }
      end
    end
  end

  context 'phase 6' do
    let(:lending_limit) { FactoryGirl.build(:lending_limit, :phase_6) }

    context 'Type E' do
      let(:loan_category_id) { 5 }

      context 'when the repayment duration is 3 years or shorter' do
        let(:total_months) { 36 }

        it { should be_empty }
      end

      context 'when the repayment duration is >= 3 years' do
        let(:total_months) { 37 }

        it { should_not be_empty }
      end
    end
  end
end
