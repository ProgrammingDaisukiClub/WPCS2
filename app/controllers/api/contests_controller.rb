class Api::ContestsController < ApplicationController
  def show
    unless contest = Contest.find(params[:id])
      render(json: {}, status: 404) && return
    end

    isUserRegistered = contest.registered_by(user)
    if !signed_in? || (!contest.ended? && !isUserRegistered) || (!contest.started? && isUserRegistered)
      render json: {
        id: params[:id],
        name: params[:lang] == 'ja' ? contest.name_ja : contest.name_en,
        description: params[:lang] == 'ja' ? contest.description_ja : contest.description_en,
        joined: isUserRegistered
      }, status: 404
    end
  end

  def entry
    render json: {}
  end

  def ranking
    render json: {}
  end
end
