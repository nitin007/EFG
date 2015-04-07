FactoryGirl.define do
  factory :recovery do
    created_by factory: :lender_user
    recovered_on { Date.current }
    total_proceeds_recovered Money.new(10_000_00)
    outstanding_non_efg_debt Money.new(10_000_00)
    non_linked_security_proceeds Money.new(10_000_00)
    linked_security_proceeds Money.new(10_000_00)
    realisations_attributable Money.new(10_000_00)
    amount_due_to_dti Money.new(10_000_00)
    total_liabilities_after_demand 0
    total_liabilities_behind 0

    after(:build) { |recovery|
      recovery.loan ||= FactoryGirl.create(:loan, :settled, settled_on: recovery.recovered_on)
    }

    trait :realised do
      realise_flag true
    end

    trait :unrealised do
      realise_flag false
    end
  end
end
