shared_examples_for 'a basic data correction' do |attribute, new_value|
  include DataCorrectionSpecHelper

  let(:loan) { FactoryGirl.create(:loan, :guaranteed, lender: current_user.lender) }
  let!(:old_value) { loan.public_send(attribute) }

  before do
    visit_data_corrections
    click_link attribute.to_s.titleize
  end

  it do
    fill_in attribute, new_value
    click_button 'Submit'

    data_correction = loan.data_corrections.last!
    data_correction.change_type.should == "ChangeType::#{attribute.to_s.classify}".constantize
    data_correction.created_by.should == current_user
    data_correction.date_of_change.should == Date.current
    data_correction.modified_date.should == Date.current
    data_correction.public_send("old_#{attribute}").should == old_value
    data_correction.public_send(attribute).should == new_value

    loan.reload
    loan.public_send(attribute).should == new_value
    loan.modified_by.should == current_user
  end
end

shared_examples_for 'a basic data correction presenter' do |attribute, new_value|
  let(:factory_name) { "#{attribute}_data_correction" }

  describe 'validations' do
    let(:presenter) { FactoryGirl.build(factory_name) }

    it 'has a valid factory' do
      presenter.should be_valid
    end

    it "requires a #{attribute}" do
      presenter.public_send("#{attribute}=", '')
      presenter.should_not be_valid
    end
  end

  describe '#save' do
    let(:user) { FactoryGirl.create(:lender_user) }
    let(:loan) { FactoryGirl.create(:loan, :guaranteed) }
    let(:presenter) { FactoryGirl.build(factory_name, created_by: user, loan: loan) }
    let!(:old_value) { loan.public_send(attribute) }

    context 'success' do
      it 'creates a DataCorrection and updates the loan' do
        presenter.public_send("#{attribute}=", new_value)
        presenter.save.should == true

        data_correction = loan.data_corrections.last!
        data_correction.created_by.should == user
        data_correction.change_type.should == "ChangeType::#{attribute.to_s.classify}".constantize
        data_correction.public_send("old_#{attribute}").should == old_value
        data_correction.public_send(attribute).should == new_value

        loan.reload
        loan.public_send(attribute).should == new_value
        loan.modified_by.should == user
      end
    end

    context 'failure' do
      it 'does not update loan' do
        presenter.public_send("#{attribute}=", nil)
        presenter.save.should == false
        loan.reload

        loan.public_send(attribute).should == old_value
      end
    end
  end

end

