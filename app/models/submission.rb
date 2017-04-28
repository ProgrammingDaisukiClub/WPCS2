class Submission < ApplicationRecord
  belongs_to :user
  belongs_to :data_set
  has_one :problem, through: :data_set
  has_one :contest, through: :problem

  delegate :problem_id, to: :data_set

  enum judge_status: {
    waiting: 0,
    wrong: 1,
    accepted: 2
  }, _prefix: true

  enum language: {
  }, _prefix: true

  def judge
    status = correct_answer? ? :accepted : :wrong

    update(
      judge_status: status,
      score: status == :wrong || created_at > contest.end_at ? 0 : judge_score
    )
  end

  def correct_answer?
    data_set_output = data_set.output.gsub(/\R/, "\n").gsub(/\s+/, "\s").strip
    submission_answer = answer.gsub(/\R/, "\n").gsub(/[\s\t]+/, "\s").strip

    data_set_output == submission_answer
  end

  def judge_score
    max_score = data_set.score
    baseline = contest.score_baseline
    score = max_score * (contest_progress_rate + baseline) / (1 + baseline)
    [0, score].max
  end

  def contest_progress_rate
    contest_time = contest.end_at - contest.start_at
    # remaining_time = contest.end_at - submitted_at_with_penalty
    remaining_time = contest.end_at - created_at
    remaining_time / contest_time
  end

  def submitted_at_with_penalty
    wrong_answers = Submission.where(
      user_id: user_id,
      data_set_id: data_set_id,
      judge_status: 'wrong'
    ).count
    created_at + 20.minute * wrong_answers
  end
end
