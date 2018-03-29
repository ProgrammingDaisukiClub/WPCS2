class ProblemsController < ApplicationController
  before_action :raise_not_found, only: %i[show]

  def show
    render template: 'contests/show'
  end

  private

  def raise_not_found
    contest = Contest.find_by(id: params.require(:contest_id))
    raise ActionController::RoutingError, 'Not Found' unless contest

    problem = contest.problems.find_by(id: params.require(:id))
    raise ActionController::RoutingError, 'Not Found' unless problem
  end
end
