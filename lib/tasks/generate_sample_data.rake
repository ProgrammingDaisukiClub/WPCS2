namespace :sample_data do
  desc 'サンプルデータを生成する'
  task generate: :environment do
    user_ids = []
    20.times do |i|
      user = User.create(
        name: "user #{i}",
        email: "sample-user-#{i}@example.com",
        password: 'password',
        password_confirmation: 'password',
        confirmed_at: 2.days.ago
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
        score_baseline: 0.5,
        status: i.zero? ? 0 : 1,
        password: i.zero? ? '' : 'password'
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
          name_ja: "問題#{i} - #{j}",
          name_en: "Problem#{i} - #{j}",
          description_ja: "問題#{i} - #{j}の説明です",
          description_en: "Description of Problem#{i} - #{j}",
          order: j
        )

        data_set_small = DataSet.create(
          label: 'Small',
          problem_id: problem.id,
          input: '1 2 3 4 5',
          output: '1 2 3 4 5',
          score: rand(1..200) * 10,
          accuracy: 0,
          order: 1
        )
        data_set_large = DataSet.create(
          label: 'Large',
          problem_id: problem.id,
          input: '1 2 3 4 5',
          output: '1 2 3 4 5',
          score: rand(1..200) * 10,
          accuracy: 0,
          order: 2
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
            data_set = rand(2) == 1 ? data_set_small : data_set_large
            judge_status = rand(3)
            Submission.create(
              user_id: user.id,
              data_set_id: data_set.id,
              answer: '1 2 3 4 5',
              judge_status: judge_status,
              score: judge_status == 2 ? rand(data_set.score) : 0
            )
          end
        end
      end
    end
  end
end
