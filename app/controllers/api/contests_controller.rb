class Api::ContestsController < ApplicationController
  include Api::ContestsRankingJson

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
end
