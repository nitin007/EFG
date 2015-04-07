require 'spec_helper'
require 'csv'

describe LoanReportPresenter do

  describe "#initialize" do
    let(:lender) { double(Lender, id: 89) }
    let(:user) { double('user', lender: lender, lender_ids: [lender.id]) }

    it "should not allow unsupported attributes" do
      expect {
        LoanReportPresenter.new(user, report_attributes(company_registration: '123456C'))
      }.to raise_error(NoMethodError)
    end
  end

  describe "validation" do
    let(:user) { FactoryGirl.create(:lender_user) }
    let(:loan_report_presenter) { LoanReportPresenter.new(user, report_attributes) }

    it 'should have a valid factory' do
      loan_report_presenter.should be_valid
    end

    it 'should be invalid without an allowed loan state' do
      loan_report_presenter.states = [ "wrong" ]
      loan_report_presenter.should_not be_valid

      loan_report_presenter.states = [ Loan::Guaranteed ]
      loan_report_presenter.should be_valid
    end

    it 'should be invalid without numeric created by user ID' do
      loan_report_presenter.created_by_id = 'a'
      loan_report_presenter.should_not be_valid
    end

    it 'should be valid with blank created by user ID' do
      loan_report_presenter.created_by_id = ''
      loan_report_presenter.should be_valid
    end

    it 'should be invalid without a loan type' do
      loan_report_presenter.loan_types = []
      loan_report_presenter.should_not be_valid
    end

    it 'should be invalid without a valid loan type' do
      loan_report_presenter.loan_types = ["Z"]
      loan_report_presenter.should_not be_valid

      loan_report_presenter.loan_types = [LoanTypes::LEGACY_SFLG.id]
      loan_report_presenter.should be_valid
    end

    it 'should be invalid without lender IDs' do
      user = FactoryGirl.create(:cfe_user)
      loan_report_presenter = LoanReportPresenter.new(user, report_attributes)

      loan_report_presenter.lender_ids = nil
      loan_report_presenter.should_not be_valid
    end

    it 'should be invalid without a numeric created by ID' do
      loan_report_presenter.created_by_id = 'a'
      loan_report_presenter.should_not be_valid
    end
  end

  describe "delegating to report" do
    let(:user) { FactoryGirl.create(:lender_user) }
    let(:loan_report) { double('LoanReport') }
    let(:presenter) { LoanReportPresenter.new(user) }
    before { presenter.stub(:report).and_return(loan_report) }

    it "delegates #count" do
      loan_report.should_receive(:count).and_return(45)
      presenter.count.should == 45
    end

    it "delgates #loans" do
      loans = double('loans')
      loan_report.should_receive(:loans).and_return(loans)
      presenter.loans.should == loans
    end
  end

  describe "permissions" do
    let(:presenter) { LoanReportPresenter.new(user) }

    context "with AuditorUser" do
      let(:user) { FactoryGirl.build(:auditor_user) }

      it "allows lender selection" do
        presenter.should have_lender_selection
      end

      it "doesn't allow created by selection" do
        presenter.should_not have_created_by_selection
      end
    end

    context "with CfeUser" do
      let(:user) { FactoryGirl.build(:cfe_user) }

      it "allows lender selection" do
        presenter.should have_lender_selection
      end

      it "allows loan type selection" do
        presenter.should have_loan_type_selection
      end

      it "doesn't allow created by selection" do
        presenter.should_not have_created_by_selection
      end
    end

    context "with LenderUser" do
      let(:user) { FactoryGirl.build(:lender_user) }

      it "doesn't allow lender selection" do
        presenter.should_not have_lender_selection
      end

      it "allows created by selection" do
        presenter.should have_created_by_selection
      end
    end

    context "with a users's 'lender' that can access all loan schemes" do
      let(:lender) { double('lender', :can_access_all_loan_schemes? => true)}
      let(:user) { FactoryGirl.build(:lender_user) }
      before { user.stub(:lender).and_return(lender) }

      it "allows loan type selection" do
        presenter.should have_loan_type_selection
      end
    end

    context "with a user's 'lender' that can't access all loan schemes" do
      let(:lender) { double('lender', :can_access_all_loan_schemes? => false)}
      let(:user) { FactoryGirl.build(:lender_user) }
      before { user.stub(:lender).and_return(lender) }

      it "doesn't allow loan type selection" do
        presenter.should_not have_loan_type_selection
      end
    end
  end

  describe "#report" do
    let(:presenter) { LoanReportPresenter.new(user, report_attributes) }

    context "with a LenderUser" do
      let(:lender) { FactoryGirl.create(:lender) }
      let(:user) { FactoryGirl.create(:lender_user, lender: lender) }

      it "sets the report's lender_ids the user's lender_id" do
        presenter.report.lender_ids.should == [lender.id]
      end
    end

    context "with a user who can select lenders" do
      let!(:lender1) { FactoryGirl.create(:lender) }
      let!(:lender2) { FactoryGirl.create(:lender) }
      let!(:lender3) { FactoryGirl.create(:lender) }
      let(:user) { FactoryGirl.build(:cfe_user) }

      it "sets lender_ids to the selected lender_ids" do
        presenter.lender_ids = [lender1.id, lender3.id]
        presenter.report.lender_ids.should == [lender1.id, lender3.id]
      end

      it "removes any lender_ids that the user can't access" do
        user.stub(:lender_ids).and_return([lender1.id, lender2.id])

        presenter.lender_ids = [lender1.id, lender3.id]
        presenter.report.lender_ids.should == [lender1.id]
      end
    end

    context "with a user who can access all loan schemes" do
      let(:lender) { FactoryGirl.create(:lender, loan_scheme: '') }
      let(:user) { FactoryGirl.create(:lender_user, lender: lender) }
      let(:presenter) { LoanReportPresenter.new(user) }

      it "doesn't set loan_types" do
        presenter.loan_types.should be_empty
      end
    end

    context "with a user who can't access all loan schemes" do
      let(:lender) { FactoryGirl.create(:lender, loan_scheme: 'E') }
      let(:user) { FactoryGirl.create(:lender_user, lender: lender) }
      let(:presenter) { LoanReportPresenter.new(user) }

      it "sets the loan_types to EFG" do
        presenter.loan_types.should == [LoanTypes::EFG]
      end
    end
  end

  private

  def report_attributes(params = {})
    lender_ids = Lender.count.zero? ? [ 1 ] : Lender.all.collect(&:id)

    {
      lender_ids: lender_ids,
      loan_types: [LoanTypes::NEW_SFLG.id, LoanTypes::EFG.id],
      states: Loan::States,
    }.merge(params)
  end

end
