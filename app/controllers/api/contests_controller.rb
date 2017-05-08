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

    if !signed_in? || @contest.ended? || (current_user && current_user.admin_role)
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
    !(current_user && current_user.admin_role) && !((@contest.during? && @joined) || @contest.ended?)
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
      admin_role: current_user.try(:admin_role).present?,
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
    {
      users: sorted_users.map do |user|
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

  def sorted_users
    @contest.users.sort { |user1, user2| @contest.user_score(user2) <=> @contest.user_score(user1) }
  end
end
