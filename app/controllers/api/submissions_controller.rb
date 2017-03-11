class Api::SubmissionsController < ApplicationController
  def index
    render json: [
      {
        id: 1,
        correct: true,
        score: 82
      },
      {
        id: 2,
        correct: false
      }
    ]
  end

  def create
    unless (contest = Contest.find_by_id(params[:contest_id]))
      render json: {}, status: 404
      return
    end

    unless signed_in?
      render json: {}, status: 403
      return
    end

    unless contest.started?
      render json: {}, status: 403
      return
    end

    if contest.during? && !contest.registered_by?(current_user)
      render json: {}, status: 403
      return
    end

    # FIXME: Fix this and test cases when judge method is implemented

    submission = Submission.create(
      user: current_user,
      data_set: DataSet.find_by_id(params[:data_set_id]),
      judge_status: 0,
      answer: params[:answer]
    )

    render json: {
      id: submission.id,
      problem_id: submission.data_set.problem.id,
      data_set_id: submission.data_set.id,
      judge_status: submission.judge_status.to_i,
      created_at: submission.created_at.to_s
    }, status: 201
  end
end
