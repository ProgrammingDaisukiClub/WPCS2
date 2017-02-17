namespace :sample_data do
  desc 'サンプルデータを生成する'
  task generate: :environment do
    user_ids = []
    20.times do |i|
      user = User.create(
        email: "sample-user-#{i}@example.com",
        password: 'password',
        password_confirmation: 'password'
      )
      user_ids << user.id
    end

    users = User.where(id: user_ids)
    3.times do |i|
      contest = Contest.create(
        name_ja: "サンプルコンテスト#{i}",
        name_en: "SampleContest#{i}",
        description_ja: "サンプルコンテスト#{i}の説明です",
        description_en: "Description of SampleContest#{i}",
        start_at: case i % 3
                  when 1 then DateTime.now
                  when 2 then DateTime.now - 1.week
                  when 0 then DateTime.now + 1.week
                  end,
        end_at: case i % 3
                when 1 then DateTime.now + 10.year
                when 2 then DateTime.now - 1.week + 2.hour
                when 0 then DateTime.now + 1.week + 2.hour
                end,
        score_baseline: 0.5
      )

      users.each do |user|
        next unless rand(2) == 1
        ContestRegistration.create(
          user_id: user.id,
          contest_id: contest.id
        )
      end

      [*4..12].sample.times do |j|
        problem = Problem.create(
          contest_id: contest.id,
          name_ja: "サンプルコンテスト#{i} - 問題#{j}",
          name_en: "SampleContest#{i} - Problem#{j}",
          description_ja: "サンプルコンテスト#{i} - 問題#{j}の説明です",
          description_en: "Description of SampleContest#{i} - Problem#{j}",
          order: j
        )

        data_set_small = DataSet.create(
          label: 'Small',
          problem_id: problem.id,
          input: '1 2 3 4 5',
          output: '1 2 3 4 5',
          score: (rand(200) + 1) * 10,
          accuracy: 0
        )
        data_set_large = DataSet.create(
          label: 'Large',
          problem_id: problem.id,
          input: '1 2 3 4 5',
          output: '1 2 3 4 5',
          score: (rand(200) + 1) * 10,
          accuracy: 0
        )

        users.each do |user|
          ended = contest.end_at <= DateTime.now
          started = contest.start_at <= DateTime.now
          registered = ContestRegistration.find_by(
            contest_id: contest.id,
            user_id: user.id
          )
          next unless ended || (started && registered)
          [*0..8].sample.times do |_k|
            Submission.create(
              user_id: user.id,
              data_set_id: rand(2) == 1 ? data_set_small.id : data_set_large.id,
              answer: '1 2 3 4 5',
              judge_status_id: 1
            )
          end
        end
      end
    end
  end
end
