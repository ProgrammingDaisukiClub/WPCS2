class Api::ContestsController < ApplicationController
  def show
    unless contest = Contest.find_by_id(params[:id])
      render(json: {}, status: 404) && return
    end

    is_user_registered = contest.registered_by(current_user)

    if !signed_in? || (!contest.ended? && !is_user_registered) || (!contest.started? && is_user_registered)
      render(json: {
               id: params[:id],
               name: params[:lang] == 'ja' ? contest.name_ja : contest.name_en,
               description: params[:lang] == 'ja' ? contest.description_ja : contest.description_en,
               joined: is_user_registered
             }, status: 404) && return
    end
    render json: {}
  end

  def entry
    render json: {}
  end

  def ranking
    render json: {}
  end
end
