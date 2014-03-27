class LoanSubCategory < StaticAssociation
  self.data = [
    {
      id: 1,
      loan_category_id: 5,
      name: 'Overdrafts'
    },
    {
      id: 2,
      loan_category_id: 5,
      name: 'Fixed Term Revolving Credit Facilities'
    },
    {
      id: 3,
      loan_category_id: 5,
      name: 'Business Credit (or Charge) Cards'
    },
    {
      id: 4,
      loan_category_id: 5,
      name: 'Bonds & Guarantees (Performance Bonds, VAT Deferment etc.)'
    },
    {
      id: 5,
      loan_category_id: 5,
      name: 'BACS facilities'
    },
    {
      id: 6,
      loan_category_id: 5,
      name: 'Stocking Finance'
    },
    {
      id: 7,
      loan_category_id: 5,
      name: 'Import Finance (Letters of Credit, Import Loans etc.)'
    },
    {
      id: 8,
      loan_category_id: 5,
      name: 'Merchant Services'
    },
    {
      id: 9,
      loan_category_id: 5,
      name: 'Multi-option Facilities (setting a limit which can be used across a variety of the above)'
    },
  ]

  def loan_category
    LoanCategory.find(loan_category_id)
  end
end
