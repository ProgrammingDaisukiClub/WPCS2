class Api::ContestsController < ApplicationController
  def show
    unless (contest = Contest.find_by_id(params[:id]))
      render(json: {}, status: 404)
      return
    end

    json_without_problems = contest.name_and_description(params[:lang])

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
    render json: {
      users: [
        id: 1,
        name: 'ユーザー名',
        problems: [
          {
            id: 1,
            data_sets: [
              { id: 1, label: 'small', solved_at: DateTime.now, score: 85 },
              { id: 2, label: 'large' }
            ]
          },
          {
            id: 2,
            data_sets: [
              { id: 3, label: 'small', solved_at: DateTime.now.tomorrow, score: 97 },
              { id: 4, label: 'small', solved_at: DateTime.now.yesterday, score: 63 }
            ]
          }
        ]
      ]
    }
  end

  private

  def show_for_no_login_user(contest, json_without_problems)
    json_without_problems = json_without_problems.merge(joined: false)
    if contest.ended?
      json_with_problems = json_without_problems.merge(json_problems)
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
      json_with_problems = json_without_problems.merge(json_problems)
      render(json: json_with_problems, status: :ok)
    end
  end

  def json_problems(contest)
    contest.problems_to_show(current_user.try(:id), params[:lang])
  end
end
