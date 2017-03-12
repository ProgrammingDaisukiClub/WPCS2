class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  has_many :contest_registrations
  has_many :contests, through: :contest_registrations
  has_many :submissions

  scope :registered_contest_id, lambda { |contest_id|
    joins(:contests).merge(Contest.id_is(contest_id))
  }

  def score_for_contest(contest_id)
    return 0 unless contest_id
    contest = Contest.find(contest_id)
    return 0 if contest.nil?
    return 0 unless contest.registered_by?(self)
    user_id = id
    scores = contest.data_sets.map { |data_set| data_set.user_score(user_id) }
    return scores.inject(:+) unless scores.nil?
    0
  end
end
