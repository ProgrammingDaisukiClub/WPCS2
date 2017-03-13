class Submission < ApplicationRecord
  belongs_to :user
  belongs_to :data_set

  delegate :problem_id, to: :data_set
  delegate :problem, to: :data_set
  delegate :contest, to: :problem

  enum judge_status: {
    waiting: 0,
    wrong: 1,
    accepted: 2
  }, _prefix: true

  enum language: {
  }, _prefix: true

  def judge
    status = answer == data_set.output ? :accepted : :wrong

    update(
      judge_status: status,
      score: status == :wrong ? 0 : judge_score
    )
  end

  def judge_score
    max_score = data_set.score
    baseline = contest.score_baseline
    score = max_score * (contest_progress_rate + baseline) / (1 + baseline)
    [0, score].max
  end

  def contest_progress_rate
    contest_time = contest.end_at - contest.start_at
    remain_time = contest.end_at - created_at
    remain_time / contest_time
  end
end
