class Api::ContestsController < ApplicationController
  def show
    unless contest = Contest.find_by_id(params[:id])
      render(json: {}, status: :not_found) && return
    end

    json_data = {
      id: params[:id].to_i,
      name: params[:lang] == 'ja' ? contest.name_ja : contest.name_en,
      description: params[:lang] == 'ja' ? contest.description_ja : contest.description_en
    }

    unless signed_in?
      render(json: json_data.merge(joined: false), status: :ok) && return
    end

    is_user_registered = contest.registered_by(current_user)

    if (!contest.ended? && !is_user_registered) || (!contest.started? && is_user_registered)
      render(json: json_data.merge(joined: is_user_registered), status: :ok) && return
    end

    render json: {}
  end

  def entry
    unless contest = Contest.find_by_id(params[:id])
      render(json: {}, status: 404) && return
    end
    render json: {}
  end

  def ranking
    render json: {}
  end
end
