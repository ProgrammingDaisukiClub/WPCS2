class DataSet < ApplicationRecord
  belongs_to :problem
  has_many :submissions, dependent: :destroy

  delegate :contest, to: :problem

  def solved_by?(user)
    return false if user.nil?
    submissions.where(user: user).judge_status_accepted.count.positive?
  end

  def solved_by_during_contest?(user)
    return false if user.nil?
    submissions.where(
      user: user,
      created_at: contest.start_at..contest.end_at
    ).judge_status_accepted.count.positive?
  end

  def user_score(user)
    return 0 if user.nil?
    submission = submissions.where(
      user: user,
      judge_status: :accepted,
      created_at: contest.start_at..contest.end_at
    ).order(score: :desc).first
    submission ? submission.score : 0
  end

  def user_solved_at(user)
    return nil if user.nil?
    submission = submissions.where(user: user, judge_status: :accepted).order(score: :desc).limit(1).first
    submission.created_at if submission && (submission.created_at < contest.end_at)
  end

  def user_wrong_answers(user)
    return 0 if user.nil?
    solved_at = user_solved_at(user)
    submissions.where(
      user_id: user.id,
      created_at: contest.start_at..(solved_at || contest.end_at)
    ).judge_status_wrong.count
  end
end
