class Api::ContestsController < ApplicationController
  def show
    unless (contest = Contest.find_by_id(params[:id]))
      render(json: {}, status: :not_found)
      return
    end

    json_without_problems = contest.name_and_description(params[:lang])

    unless signed_in?
      json_without_problems = json_without_problems.merge(joined: false)
      if contest.ended?
        json_with_problems = json_without_problems.merge(contest.problems_to_show(params[:lang]))
        render(json: json_with_problems, status: :ok)
      else
        render(json: json_without_problems, status: :ok)
      end
      return
    end

    is_user_registered = contest.registered_by?(current_user)
    json_without_problems = json_without_problems.merge(joined: is_user_registered)

    if !contest.started? || (!contest.ended? && !is_user_registered)
      render(json: json_without_problems, status: :ok)
    else
      json_with_problems = json_without_problems.merge(contest.problems_to_show(params[:lang]))
      render(json: json_with_problems, status: :ok)
    end
  end

  def entry
    unless (contest = Contest.find_by_id(params[:id]))
      render(json: {}, status: 404)
      return
    end

    if !signed_in? || contest.ended?
      render(json: {}, status: 403)
      return
    end

    if contest.registered_by?(current_user)
      render(json: {}, status: 409)
      return
    end

    if contest.register(user)
      render(json: {}, status: 201)
      return
    end

    render json: {}
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
end
