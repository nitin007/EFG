class LoanSubCategory < StaticAssociation
  self.data = [
    {
      id: 1,
      loan_category_id: LoanCategory::TypeE.id,
      name: 'Overdrafts'
    },
    {
      id: 2,
      loan_category_id: LoanCategory::TypeE.id,
      name: 'Fixed Term Revolving Credit Facilities'
    },
    {
      id: 3,
      loan_category_id: LoanCategory::TypeE.id,
      name: 'Business Credit (or Charge) Cards'
    },
    {
      id: 4,
      loan_category_id: LoanCategory::TypeE.id,
      name: 'Bonds & Guarantees (Performance Bonds, VAT Deferment etc.)'
    },
    {
      id: 5,
      loan_category_id: LoanCategory::TypeE.id,
      name: 'BACS facilities'
    },
    {
      id: 6,
      loan_category_id: LoanCategory::TypeE.id,
      name: 'Stocking Finance'
    },
    {
      id: 7,
      loan_category_id: LoanCategory::TypeE.id,
      name: 'Import Finance (Letters of Credit, Import Loans etc.)'
    },
    {
      id: 8,
      loan_category_id: LoanCategory::TypeE.id,
      name: 'Merchant Services'
    },
    {
      id: 9,
      loan_category_id: LoanCategory::TypeE.id,
      name: 'Multi-option Facilities (setting a limit which can be used across a variety of the above)'
    },
  ]

  def loan_category
    LoanCategory.find(loan_category_id)
  end
end
