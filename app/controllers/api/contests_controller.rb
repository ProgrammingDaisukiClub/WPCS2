class Api::ContestsController < ApplicationController
  def show
    unless (contest = Contest.find_by_id(params[:id]))
      render(json: {}, status: :not_found)
      return
    end

    json_without_problems = contest.get_without_problems(params[:lang])

    unless signed_in?
      json_without_problems = json_without_problems.merge(joined: false)
      if contest.ended?
        json_with_problems = json_without_problems.merge(contest.get_problems(params[:lang]))
        render(json: json_with_problems, status: :ok)
        return
      else
        render(json: json_without_problems, status: :ok)
        return
      end
    end

    is_user_registered = contest.registered_by(current_user)
    json_without_problems = json_without_problems.merge(joined: is_user_registered)

    if (!contest.ended? && !is_user_registered) || (!contest.started? && is_user_registered)
      render(json: json_without_problems, status: :ok)
      return
    end

    if (contest.during? && is_user_registered) || contest.ended?
      json_with_problems = json_without_problems.merge(contest.get_problems(params[:lang]))
      render(json: json_with_problems, status: :ok)
      return
    end

    render json: {}
  end

  def entry
    unless contest = Contest.find_by_id(params[:id])
      render(json: {}, status: 404)
      return
    end

    if !signed_in? || contest.ended?
      render(json: {}, status: 403)
      return
    end
    
    if contest.registered_by(current_user)
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
    render json: {}
  end
end
