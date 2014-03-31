FactoryGirl.define do
  factory :sic_code do
    sequence(:code) { |n| n.to_s }
    description 'Growing of rice'
    eligible true
    public_sector_restricted false
    active true
    state_aid_threshold 200000

    trait :ineligible do
      eligible false
    end
  end
end
