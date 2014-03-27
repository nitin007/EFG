FactoryGirl.define do
  factory :sic_code do
    sequence(:code) { |n| n.to_s }
    description 'Growing of rice'
    eligible true
    public_sector_restricted false
    active true

    trait :ineligible do
      eligible false
    end
  end
end
