FactoryGirl.define do
  factory :loan_report do
    loan_source "S"
    loan_scheme "E"
    lender_ids [1]
    allowed_lender_ids [1]
  end
end
