class Api::SubmissionsController < ApplicationController
  def index
    unless (contest = Contest.find_by_id(params[:contest_id]))
      render json: {}, status: 404
      return
    end

    if prevent_show?(contest)
      render json: {}, status: 403
      return
    end

    render json: json_create_for_index(contest.submissions.where(user: current_user).order(id: :asc)), status: 200
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

    submission = create_and_judge_submission

    render json: json_create(submission), status: 201
  end

  private

  def json_create_for_index(submissions)
    submissions.map do |submission|
      data = {
        id: submission.id,
        problem_id: submission.problem_id,
        data_set_id: submission.data_set_id,
        judge_status: submission.judge_status_before_type_cast,
        created_at: submission.created_at
      }
      next data unless submission.judge_status_accepted?
      data.merge(score: submission.score)
    end
  end

  def json_create(submission)
    {
      id: submission.id,
      problem_id: submission.problem_id,
      data_set_id: submission.data_set_id,
      judge_status: submission.judge_status_before_type_cast,
      score: submission.score,
      created_at: submission.created_at
    }
  end

  def prevent_submission?(contest)
    !signed_in? || !contest.started? || (contest.during? && !contest.registered_by?(current_user))
  end

  def prevent_show?(contest)
    !contest.ended? && (!signed_in? || !contest.registered_by?(current_user))
  end

  def create_and_judge_submission
    data_set = DataSet.find(params.required(:data_set_id))
    answer = params.required(:answer)

    submission = Submission.create(
      user: current_user,
      data_set: data_set,
      judge_status: :waiting,
      answer: answer
    )

    # submission.judge
    submission
  end
end
