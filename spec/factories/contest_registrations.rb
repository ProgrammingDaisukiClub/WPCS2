FactoryGirl.define do
  factory :contest_registration do
    after(:create) do |cr|
      cr.contest.problems.each do |p|
        p.data_sets.each do |ds|
          [*0..5].sample.times do
            create(:submission, user: cr.user, data_set: ds)
          end
        end
      end
    end
  end
end
