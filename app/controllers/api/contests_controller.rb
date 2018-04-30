class Api::ContestsController < ApplicationController
  include Api::ContestsRankingJson

  protect_from_forgery except: ['validation']
  before_action :set_contest

  def show
    if hide_problems?
      render(json: @contest.show_without_problems(@joined, current_user), status: 200)
    elsif hide_editorial?
      render(json: @contest.show_with_problems(@joined, current_user), status: 200)
    else
      render(json: @contest.show_with_problems_and_editorial(@joined, current_user), status: 200)
    end
  end

  def entry
    if @joined
      render(json: {}, status: 409)
      return
    end

    if !signed_in? || @contest.ended? || (current_user&.admin_role)
      render(json: {}, status: 403)
      return
    end

    @contest.register(current_user)
    render(json: {}, status: 201)
  end

  def ranking
    if hide_problems?
      render(json: {}, status: 403)
      return
    end

    render(json: json_for_ranking, status: 200)
  end

  def status
    contest_status = @contest.status
    render(json: {
             'status': contest_status
           }, status: 200)
  end

  def validation
    if @contest.inside?
      password = params['password']
      render(json: {
               'result': password == @contest.password ? 'ok' : 'failed'
             }, status: 200)
    else
      render(json: {
               'result': 'failed',
               'message': 'this api is not supported when status == 0 contest'
             }, status: 200)
    end
  end

  private

  def set_contest
    unless (@contest = Contest.find_by_id(params[:id]))
      render(json: {}, status: 404)
      return
    end
    @joined = signed_in? && @contest.registered_by?(current_user)
  end

  def hide_problems?
    !(current_user&.admin_role) && !((@contest.during? && @joined) || @contest.ended?)
  end

  def hide_editorial?
    !@contest.ended?
  end
end
