class DataSetsController < ApplicationController
  before_action :set_data_set, only: %i(show)

  def show
  	send_data(
       @data_set.input,
       filename: "input_#{@contest.id}_#{@problem.id}_#{@data_set.id}.in",
       type: 'text/txt',
       disposition: 'attachment',
       status: 200
     )
  end

  private
  def set_data_set
    @contest = Contest.find(params[:contest_id])
    raise ActionController::RoutingError, 'Not Found' unless (@contest.registered_by?(current_user) && @contest.during?) || @contest.ended?
    @problem = Problem.find(params[:problem_id])
    @data_set = DataSet.find(params[:id])
  end
end
