FactoryBot.define do
  factory :data_set do
    sequence(:label) { |n| "label of data_set#{n}" }
    input 'input of data_set'
    output 'output of data_set'
    sequence(:score) { |n| n * 10 }
    accuracy 0
    sequence(:order) { |n| n }
  end
end
