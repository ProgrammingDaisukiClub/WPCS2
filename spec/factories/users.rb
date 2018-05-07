FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user #{n}" }
    sequence(:email) { |n| "user-#{n}@example.com" }
    password 'password'
    confirmed_at 3.days.ago
  end

  factory :admin_user, parent: :user do
    after(:create) do |admin_user|
      create(:admin_role, user_id: admin_user.id)
    end
  end
end
