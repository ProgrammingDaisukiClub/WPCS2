class SubmissionsController < ApplicationController
  before_action :raise_not_found, only: %i[index]

  def index
    render template: 'contests/show'
  end

  private

  def raise_not_found
    @contest = Contest.find_by(id: params.require(:contest_id))
    raise ActionController::RoutingError, 'Not Found' unless @contest

    @header_style = @contest.outside? ? 'outside' : 'inside'
  end
end
