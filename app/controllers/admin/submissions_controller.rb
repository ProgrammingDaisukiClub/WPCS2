class Admin::SubmissionsController < ApplicationController
  def index
    data_set_ids = Contest.find_by_id(params[:contest_id]).data_sets.pluck(:id)
    @submissions = Submission
    .where(data_set_id: data_set_ids)
    .page(params[:page]).per(30).order(created_at: :desc)
    .includes(:user, :data_set, :problem)
  end
end
