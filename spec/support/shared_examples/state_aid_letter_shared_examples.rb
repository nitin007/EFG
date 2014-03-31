shared_examples_for 'State Aid Letter PDF' do

  let(:loan) { FactoryGirl.create(:loan, :completed, :offered) }

  let(:pdf_content) {
    state_aid_letter = described_class.new(loan)
    reader = PDF::Reader.new(StringIO.new(state_aid_letter.render))
    # Note: replace line breaks to make assertions easier
    reader.pages.collect { |page| page.to_s }.join(" ").gsub("\n", ' ')
  }

  describe "#render" do

    it "should contain address fields" do
      pdf_content.should include('Name')
      pdf_content.should include('Address')
      pdf_content.should include('Date')
    end

    it "should contain a title" do
      pdf_content.should include(I18n.t('pdfs.state_aid_letter.title').upcase)
    end

    it "should contain loan details" do
      pdf_content.should include(loan.business_name)
      pdf_content.should include(loan.lender.name)
      pdf_content.should include(loan.reference)
      pdf_content.should include(loan.amount.format)
      pdf_content.should include(loan.repayment_duration.total_months.to_s)
    end

    it "should contain state aid calculation" do
      pdf_content.should include(I18n.t('pdfs.state_aid_letter.state_aid', amount: loan.state_aid.format))
    end

  end
end
