class DataSet < ApplicationRecord
  belongs_to :problem
  has_many :submissions, dependent: :destroy

  delegate :contest, to: :problem

  def solved_by?(user)
    return false if user.nil?
    submissions.where(user_id: user.id).judge_status_accepted.count > 0
  end

  def user_score(user)
    return 0 if user.nil?
    submission = submissions.where(
      user_id: user.id,
      judge_status: :accepted,
      created_at: contest.start_at..contest.end_at
    ).order(score: :desc).first
    submission ? submission.score : 0
  end

  def user_solved_at(user)
    return nil if user.nil?
    submission = submissions.where(user_id: user.id, judge_status: :accepted).order(score: :desc).limit(1).first
    submission ? submission.created_at : nil
  end
end
