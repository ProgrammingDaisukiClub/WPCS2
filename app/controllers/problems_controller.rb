class ProblemsController < ApplicationController
  before_action :raise_not_found, only: %i(show)

  def show
    render template: 'contests/show'
  end

  # GET /problem/1
  def download_input
    data_set = DataSet.find(params[:data_set_id])
    send_data(
      data_set.input, 
      filename: "input_#{params[:contest_id]}_#{params[:id]}_#{data_set.id}.in",
      type: 'text/txt',
      disposition: 'attachment',
      status: 200,
      ) 
  end

  private

  def raise_not_found
    contest = Contest.find_by(id: params.require(:contest_id))
    raise ActionController::RoutingError, 'Not Found' unless contest

    problem = contest.problems.find_by(id: params.require(:id))
    raise ActionController::RoutingError, 'Not Found' unless problem
  end
end
