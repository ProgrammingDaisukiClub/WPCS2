FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user-#{n}@example.com" }
    password 'password'
    confirmed_at 3.days.ago
  end
end
