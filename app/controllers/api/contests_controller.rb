class Api::ContestsController < ApplicationController
  def show
    unless (contest = Contest.find_by_id(params[:id]))
      render(json: {}, status: 404)
      return
    end

    json_without_problems = contest.name_and_description(I18n.locale)

    unless signed_in?
      show_for_no_login_user(contest, json_without_problems)
      return
    end

    show_for_login_user(contest, json_without_problems)
  end

  def entry
    unless (contest = Contest.find_by_id(params[:id]))
      render(json: {}, status: 404)
      return
    end

    if !signed_in? || contest.ended?
      render(json: {}, status: 403)
    elsif contest.registered_by?(current_user)
      render(json: {}, status: 409)
    elsif contest.register(current_user)
      render(json: {}, status: 201)
    end
  end

  def ranking
    contest = Contest.find_by_id(params[:id])

    generate_ranking_response(contest)
  end

  private

  def generate_ranking_response(contest)
    if contest.nil?
      render(json: {}, status: 404)
      return
    end

    if contest.preparing? || (contest.during? && !(signed_in? && contest.registered_by?(current_user)))
      render(json: {}, status: 403)
      return
    end

    ranking_for_login_user(contest)
  end

  def show_for_no_login_user(contest, json_without_problems)
    json_without_problems = json_without_problems.merge(joined: false)
    if contest.ended?
      json_with_problems = json_without_problems.merge(json_problems(contest))
      render(json: json_with_problems, status: :ok)
    else
      render(json: json_without_problems, status: :ok)
    end
  end

  def show_for_login_user(contest, json_without_problems)
    is_user_registered = contest.registered_by?(current_user)
    json_without_problems = json_without_problems.merge(joined: is_user_registered)

    if !contest.started? || (!contest.ended? && !is_user_registered)
      render(json: json_without_problems, status: :ok)
    else
      json_with_problems = json_without_problems.merge(json_problems(contest))
      render(json: json_with_problems, status: :ok)
    end
  end

  def ranking_for_login_user(contest)
    users = contest.users_sorted_by_rank
    render(
      json: {
        users: users.map do |user|
          {
            id: user.id,
            name: user.name,
            total_score: user.score_for_contest(contest)
          }.merge(contest.problems_for_ranking(user.id))
        end
      },
      status: :ok
    )
  end

  def json_problems(contest)
    contest.problems_to_show(current_user.try(:id), I18n.locale)
  end
end
