module Api::ContestsRankingJson
  extend ActiveSupport::Concern

  def json_for_ranking
    @users = @contest.users
    @problems = @contest.problems.includes(:data_sets).includes(:data_sets)
    @submissions = @contest.submissions
                           .where(created_at: @contest.start_at..@contest.end_at)
                           .order(:created_at).includes(:data_set, :problem, :user)

    table = create_ranking_table
    calculate_ranking_score table
    talbe_to_json table
  end

  def create_ranking_table
    table = {}
    @users.map do |user|
      table[user.id] = initial_user_json(user)
      @problems.map do |problem|
        table[user.id][:problems][problem.id] = initial_problem_json(problem)
        problem.data_sets.map do |data_set|
          table[user.id][:problems][problem.id][:data_sets][data_set.id] = initial_data_set_json(data_set)
        end
      end
    end
    table
  end

  def initial_user_json(user)
    {
      id: user.id,
      name: user.name,
      total_score: 0,
      problems: {}
    }
  end

  def initial_problem_json(problem)
    {
      id: problem.id,
      data_sets: {}
    }
  end

  def initial_data_set_json(data_set)
    {
      id: data_set.id,
      label: data_set.label,
      correct: false,
      score: 0,
      solved_at: nil,
      wrong_answers: 0
    }
  end

  def calculate_ranking_score(table)
    @submissions.map do |submission|
      user_id = submission.user.id
      problem_id = submission.problem.id
      data_set_id = submission.data_set.id
      user_data = table[user_id]
      data = table[user_id][:problems][problem_id][:data_sets][data_set_id]
      update_ranking_score(submission, user_data, data) unless data[:correct]
    end
  end

  def update_ranking_score(submission, user_data, data)
    if submission.judge_status_accepted?
      user_data[:total_score] = user_data[:total_score] + submission.score
      data.merge!(
        correct: true,
        score: submission.score,
        solved_at: submission.created_at
      )
    elsif submission.judge_status_wrong?
      data.merge!(
        wrong_answers: data[:wrong_answers] + 1
      )
    end
  end

  def talbe_to_json(table)
    @users.map do |user|
      @problems.map do |problem|
        data = table[user.id][:problems][problem.id]
        data[:data_sets] = data[:data_sets].values
      end
      data = table[user.id]
      data[:problems] = data[:problems].values
    end
    users_json = table.values
    { users: users_json.sort { |user1, user2| user2[:total_score] <=> user1[:total_score] } }
  end
end
