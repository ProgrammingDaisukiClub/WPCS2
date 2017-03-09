FactoryGirl.define do
  factory :submission do
    sequence(:answer) { |n| "ans #{n}" }
    sequence(:code) { |n| "hello world #{n}" }
    js = [*0..2].sample
    judge_status js
    score rand(500 + 1) if js == :accepted
  end
end
