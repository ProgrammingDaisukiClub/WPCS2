class Api::ContestsController < ApplicationController
  before_action :set_contest

  def show
    if hide_problems?
      render(json: @contest.show_without_problems(@joined, current_user), status: 200)
    elsif hide_editorial?
      render(json: @contest.show_with_problems(@joined, current_user), status: 200)
    else
      render(json: @contest.show_with_problems_and_editorial(@joined, current_user), status: 200)
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

  def hide_editorial?
    !@contest.ended?
  end

  def json_for_ranking
    {
      users: @contest.sorted_users.map do |user|
        {
          id: user.id,
          name: user.name,
          total_score: @contest.user_score(user),
          problems: @contest.problems.includes(:data_sets).map do |problem|
            {
              id: problem.id,
              data_sets: problem.data_sets.order(order: :asc).includes(:submissions).map do |data_set|
                {
                  id: data_set.id,
                  label: data_set.label,
                  correct: data_set.solved_by_during_contest?(user),
                  score: data_set.user_score(user),
                  solved_at: data_set.user_solved_at(user),
                  wrong_answers: data_set.user_wrong_answers(user)
                }
              end
            }
          end
        }
      end
    }
  end
end
