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

    if prevent_submission?(contest)
      render json: {}, status: 403
      return
    end

    # FIXME: Fix this and test cases when judge method is implemented
    submission = Submission.create(
      user: current_user,
      data_set_id: params[:data_set_id],
      judge_status: 0,
      answer: params[:answer]
    )

    render json: json_create(submission), status: 201
  end

  private

  def json_create(submission)
    {
      id: submission.id,
      problem_id: submission.problem_id,
      data_set_id: submission.data_set_id,
      judge_status: submission.judge_status.to_i,
      created_at: submission.created_at.to_s
    }
  end

  def prevent_submission?(contest)
    !signed_in? || !contest.started? || (contest.during? && !contest.registered_by?(current_user))
  end
end
