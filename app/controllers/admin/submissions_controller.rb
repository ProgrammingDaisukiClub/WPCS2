class Admin::SubmissionsController < ApplicationController
  SUBMISSIONS_PER_PAGE = 30

  def index
    @contest = Contest.find_by_id(params[:contest_id])
    @submissions = @contest.submissions
                           .page(params[:page]).per(SUBMISSIONS_PER_PAGE)
                           .reorder(created_at: :desc)
                           .includes(:problem, :data_set, :user)
  end
end
