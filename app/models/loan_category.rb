class LoanCategory < StaticAssociation
  self.data = [
    {
      id: 1,
      name: 'Type A - New Term Loan with No Security'
    },
    {
      id: 2,
      name: 'Type B - New Term Loan with Partial Security'
    },
    {
      id: 3,
      name: 'Type C - New Term Loan for Overdraft Refinancing'
    },
    {
      id: 4,
      name: 'Type D - New Term Loan for Debt Consolidation or Refinancing'
    },
    {
      id: 5,
      name: 'Type E - Revolving Credit Guarantee'
    },
    {
      id: 6,
      name: 'Type F - Invoice Finance Guarantee Facility'
    },
    {
      id: 7,
      name: 'Type G - Revolving Credit Refinance Guarantee'
    },
    {
      id: 8,
      name: 'Type H - Invoice Finance Refinance Guarantee'
    }
  ]

  TypeA = find(1)
  TypeB = find(2)
  TypeC = find(3)
  TypeD = find(4)
  TypeE = find(5)
  TypeF = find(6)
  TypeG = find(7)
  TypeH = find(8)
end
