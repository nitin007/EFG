FactoryGirl.define do
  factory :user do
    first_name 'Joe'
    last_name 'Bloggs'
    sequence(:email) { |n| "joe#{n}@example.com" }
    password 'password'

    factory :lender_user, class: LenderUser do
      lender
    end
  end
end
