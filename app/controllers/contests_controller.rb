class ContestsController < ApplicationController
  before_action :raise_not_found, only: %i(show ranking)

  def show; end

  def ranking
    render action: :show
  end

  private def raise_not_found
    contest = Contest.find_by(id: params.require(:id))
    raise ActionController::RoutingError, 'Not Found' unless contest
  end
end
