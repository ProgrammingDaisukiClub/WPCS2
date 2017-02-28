class Api::ContestsController < ApplicationController
  def show
    if !signed_in? && !Contest.exists?(id: params[:id])
      render json: { error: '404 error' }, status: 404
    else
      render json: {}
    end
  end

  def entry
    render json: {}
  end

  def ranking
    render json: {}
  end
end
