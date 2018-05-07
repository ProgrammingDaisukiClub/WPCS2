FactoryBot.define do
  factory :submission do
    sequence(:answer) { |n| "ans #{n}" }
    sequence(:code) { |n| "hello world #{n}" }
  end
end
