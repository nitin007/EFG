module LoanAmendmentsHelper
  def format_amendment_value(value)
    case value
    when Date
      value.to_s(:screen)
    when LendingLimit
      value.name
    when Money
      value.format
    when RepaymentFrequency
      value.name
    else
      value
    end
  end

  def loan_amendment_type_param(loan_amendment)
    loan_amendment.class.base_class.name.tableize
  end
end
