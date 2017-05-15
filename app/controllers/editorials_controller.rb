class EditorialsController < ApplicationController
  before_action :raise_not_found, only: %i(index)

  def show
    render template: 'contests/show'
  end

  private

  def raise_not_found
    @editorial = Editorial.find_by(contest_id: params.require(:contest_id))
    raise ActionController::RoutingError, 'Not Found' unless @editorial
  end

end
