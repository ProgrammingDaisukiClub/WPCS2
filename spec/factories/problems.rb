FactoryBot.define do
  factory :problem do
    sequence(:name_ja) { |n| "問題#{n}の名前" }
    sequence(:name_en) { |n| "name of problem#{n}" }
    sequence(:description_ja) { |n| "問題#{n}の詳細" }
    sequence(:description_en) { |n| "description of problem#{n}" }
    sequence(:order) { |n| n }

    after(:create) do |problem|
      2.times { problem.data_sets << create(:data_set, problem_id: problem.id) }
    end
  end
end
