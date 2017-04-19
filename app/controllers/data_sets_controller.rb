class DataSetsController < ApplicationController
  before_action :set_data_set, only: %i(show)

  def show
    true_condition1 = (user_signed_in? && @contest.registered_by?(current_user) && @contest.during?) || @contest.ended?
    raise ActionController::RoutingError, 'Not Found' unless true_condition1
    send_data(@data_set.input,
              filename: "input_#{@contest.id}_#{@problem.id}_#{@data_set.id}.in",
              type: 'text/txt',
              disposition: 'attachment',
              status: 200)
  end

  private

  def set_data_set
    @contest = Contest.find(params[:contest_id])
    @problem = @contest.problems.find(params[:problem_id])
    @data_set = @problem.data_sets.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    raise ActionController::RoutingError, 'Not Found'
  end
end
