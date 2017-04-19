FactoryGirl.define do
  factory :contest do
    sequence(:name_ja)        { |n| "コンテスト#{n}の名前" }
    sequence(:name_en)        { |n| "name of contest#{n}" }
    sequence(:description_ja) { |n| "コンテスト#{n}の詳細" }
    sequence(:description_en) { |n| "description of contest#{n}" }
    score_baseline 0.5

    after(:create) do |contest|
      2.times { contest.problems << create(:problem, contest_id: contest.id) }
      2.times { contest.users << create(:user) }
    end
  end

  factory :contest_preparing, parent: :contest do
    start_at 1.week.since
    end_at   2.week.since
  end

  factory :contest_holding, parent: :contest do
    start_at 1.week.ago
    end_at   1.week.since
  end

  factory :contest_ended, parent: :contest do
    start_at 2.week.ago
    end_at   1.week.ago
  end
end
