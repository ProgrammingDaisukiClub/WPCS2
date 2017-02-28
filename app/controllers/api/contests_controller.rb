class Api::ContestsController < ApplicationController
  def show
    if !Contest.exists?(id: params[:id])
      return render json: { error: '404 error' }, status: 404
    end
    contest = Contest.find(params[:id])

    if (!signed_in?) || (signed_in? && Time.now < contest.end_at && !ContestRegistration.find_by(user_id: user.id).present?)  || (signed_in? && Time.now < contest.start_at && ContestRegistration.find_by(user_id: user.id).present?)
      render json: {
        id: params[:id],
        name: params[:lang] == 'ja' ? contest.name_ja : contest.name_en,
        description: params[:lang] == 'ja' ? contest.description_ja : contest.description_en,
        joined: ContestRegistration.find_by(user_id: user.id).present?
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
