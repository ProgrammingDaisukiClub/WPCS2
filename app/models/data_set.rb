class DataSet < ApplicationRecord
  belongs_to :problem
  has_many :submissions

  def solved_by?(user_id)
    return false unless user_id
    submissions.where(user_id: user_id).judge_status_accepted.count > 0
  end

  def user_score(user_id)
    return 0 unless user_id
    submission = submissions.where(user_id: user_id).judge_status_accepted.order(score: :desc).limit(1).first
    return 0 unless submission
    submission.score
  end
end
