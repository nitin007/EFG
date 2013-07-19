require 'spec_helper'
require 'verde_transfer'

describe VerdeTransfer do
  describe "#run" do
    let!(:system_user) { FactoryGirl.create(:system_user) }
    let(:original_lender) { FactoryGirl.create(:lender, name: "Original") }
    let(:new_lender) { FactoryGirl.create(:lender, name: "New") }
    let!(:lending_limit_1) { FactoryGirl.create(:lending_limit, lender: original_lender, name: "A") }
    let!(:lending_limit_2) { FactoryGirl.create(:lending_limit, lender: original_lender, name: "B") }
    let(:loan_1) { FactoryGirl.create(:loan, lender: original_lender, lending_limit: lending_limit_1) }
    let(:loan_2) { FactoryGirl.create(:loan, lender: original_lender, lending_limit: lending_limit_1) }
    let(:loan_3) { FactoryGirl.create(:loan, lender: original_lender, lending_limit: lending_limit_2) }
    let(:loan_4) { FactoryGirl.create(:loan, lender: original_lender, lending_limit: nil) }
    let(:loans_references) { [loan_1, loan_2, loan_3, loan_4].map(&:reference) }

    before do
      # TODO: Loan factory doesn't allow a nil lending_limit.
      loan_4.update_column(:lending_limit_id, nil)
    end

    context "transferring loans" do
      before { VerdeTransfer.run(original_lender, new_lender, loans_references) }

      shared_examples "transferred loan" do
        subject { loan }
        before { loan.reload }

        its(:lender) { should == new_lender }

        context "loan state change" do
          subject { loan.state_changes.last }

          it do
            subject.modified_by.should == system_user
            subject.event.should == LoanEvent::EFGTransfer
            subject.state.should == loan.state
          end
        end
      end

      context "loan 1" do
        let(:loan) { loan_1 }
        it_behaves_like "transferred loan"
      end

      context "loan 2" do
        let(:loan) { loan_2 }
        it_behaves_like "transferred loan"
      end

      context "loan 3" do
        let(:loan) { loan_3 }
        it_behaves_like "transferred loan"
      end

      context "loan 4" do
        let(:loan) { loan_4 }
        it_behaves_like "transferred loan"
      end
    end

    context 'lending limits' do
      it 'the correct number are created' do
        expect {
          VerdeTransfer.run(original_lender, new_lender, loans_references)
        }.to change(LendingLimit, :count).by(2)
      end

      context "copying existing lending limit details" do
        before { VerdeTransfer.run(original_lender, new_lender, loans_references) }

        shared_examples "lending limit copy" do
          it "has the correct attributes" do
            subject.should_not == original_lending_limit
            subject.loans.should =~ loans
            subject.modified_by.should == system_user

            [:allocation_type_id, :active, :allocation, :starts_on,
             :ends_on, :name, :premium_rate, :guarantee_rate, :phase_id].each do |attr|
              subject.send(attr).should == original_lending_limit.send(attr)
            end
          end
        end

        context "loans 1 and 2" do
          subject { new_lender.lending_limits.find_by_name!("A") }

          it_behaves_like "lending limit copy" do
            let(:loans) { [loan_1, loan_2] }
            let(:original_lending_limit) { lending_limit_1 }
          end
        end

        context "loan 3" do
          subject { new_lender.lending_limits.find_by_name!("B") }

          it_behaves_like "lending limit copy" do
            let(:loans) { [loan_3] }
            let(:original_lending_limit) { lending_limit_2 }
          end
        end
      end
    end
  end
end
