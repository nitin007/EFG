FactoryGirl.define do
  factory :loan_realisation do
    realisation_statement
    realised_loan { FactoryGirl.create(:loan) }
    association :created_by, factory: :user
    realised_amount Money.new(1_000_00)

    trait(:pre)  { post_claim_limit false }
    trait(:post) { post_claim_limit true }
  end
end
