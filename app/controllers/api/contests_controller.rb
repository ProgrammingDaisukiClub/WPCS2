class Api::ContestsController < ApplicationController
  before_action :set_contest

  def show
    if hide_problems?
      render(json: json_for_show_without_problems, status: 200)
    else
      render(json: json_for_show_with_problems, status: 200)
    end
  end

  def entry
    if @joined
      render(json: {}, status: 409)
      return
    end

    if !signed_in? || @contest.ended?
      render(json: {}, status: 403)
      return
    end

    @contest.register(current_user)
    render(json: {}, status: 201)
  end

  def ranking
    if hide_problems?
      render(json: {}, status: 403)
      return
    end

    render(json: json_for_ranking, status: 200)
  end

  private

  def set_contest
    unless (@contest = Contest.find_by_id(params[:id]))
      render(json: {}, status: 404)
      return
    end
    @joined = signed_in? && @contest.registered_by?(current_user)
  end

  def hide_problems?
    !((@contest.during? && @joined) || @contest.ended?)
  end

  def json_for_show_without_problems
    {
      id: @contest.id,
      name: @contest.name,
      description: @contest.description,
      start_at: @contest.start_at,
      end_at: @contest.end_at,
      baseline: @contest.score_baseline,
      current_user_id: current_user.try(:id),
      joined: @joined
    }
  end

  def json_for_show_with_problems
    json_for_show_without_problems.merge(
      problems: @contest.problems.map do |problem|
        {
          id: problem.id,
          name: problem.name,
          description: problem.description,
          data_sets: problem.data_sets.order(order: :asc).map do |data_set|
            {
              id: data_set.id,
              label: data_set.label,
              max_score: data_set.score,
              correct: data_set.solved_by?(current_user),
              score: data_set.user_score(current_user)
            }
          end
        }
      end
    )
  end

  def json_for_ranking
    @users = @contest.users
    @problems = @contest.problems.includes(:data_sets)
    @submissions = @contest.submissions.where(created_at: @contest.start_at..@contest.end_at)

    binding.pry

    table = {}
    @users.map do |user|
      table[user.id] = {
        id: user.id,
        name: user.name,
        total_score: 0,
        problems: {}
      }
      @problems.map do |problem|
        table[user.id][:problems][problem.id] = {
          id: problem.id,
          data_sets: {}
        }
        problem.data_sets.map do |data_set|
          table[user.id][:problems][problem.id][:data_sets][data_set.id] = {
            id: data_set.id,
            label: data_set.label,
            correct: false,
            score: 0,
            solved_at: nil,
            wrong_answers: 0
          }
        end
      end
    end

    @submissions.map do |submission|
      user_id = submission.user_id
      problem_id = submission.problem_id
      data_set_id = submission.data_set_id
      data = table[user_id][:problems][problem_id][:data_sets][data_set_id]

      if !data[:correct]
        if submission.judge_status_accepted?
          table[user_id][:total_score] = table[user_id][:total_score] + submission.score
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
    end

    @users.map do |user|
      @problems.map do |problem|
        data = table[user.id][:problems][problem.id]
        data[:data_sets] = data[:data_sets].values
      end
      data = table[user.id]
      data[:problems] = data[:problems].values
    end
    table = table.values

    {
      users: table.sort { |user1, user2| user2[:total_score] <=> user1[:total_score] }
    }

    # {
    #   users: sorted_users.map do |user|
    #     {
    #       id: user.id,
    #       name: user.name,
    #       total_score: @contest.user_score(user),
    #       problems: @contest.problems.includes(:data_sets).map do |problem|
    #         {
    #           id: problem.id,
    #           data_sets: problem.data_sets.order(order: :asc).includes(:submissions).map do |data_set|
    #             {
    #               id: data_set.id,
    #               label: data_set.label,
    #               correct: data_set.solved_by_during_contest?(user),
    #               score: data_set.user_score(user),
    #               solved_at: data_set.user_solved_at(user),
    #               wrong_answers: data_set.user_wrong_answers(user)
    #             }
    #           end
    #         }
    #       end
    #     }
    #   end
    # }
  end

  def sorted_users
    @contest.users.sort { |user1, user2| @contest.user_score(user2) <=> @contest.user_score(user1) }
  end
end
