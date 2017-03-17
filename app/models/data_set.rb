class DataSet < ApplicationRecord
  belongs_to :problem
  has_many :submissions, dependent: :destroy

  delegate :contest, to: :problem

  def solved_by?(user_id)
    return false unless user_id
    submissions.where(user_id: user_id).judge_status_accepted.count > 0
  end

  def user_score(user_id)
    return 0 if user_id.nil?
    range = contest.start_at..contest.end_at
    submission = submissions.where(
      user: user_id,
      judge_status: :accepted,
      created_at: range
    ).order(score: :desc).first
    return 0 if submission.nil?
    submission.score
  end

  def user_solved_at(user_id)
    return 0 if user_id.nil?
    submission = submissions.where(user: user_id, judge_status: :accepted).order(score: :desc).limit(1).first
    return 0 if submission.nil?
    submission.created_at
  end

  def to_json_hash(user_id)
    {
      id: id,
      label: label,
      max_score: score,
      correct: solved_by?(user_id),
      score: user_score(user_id)
    }
  end
end
