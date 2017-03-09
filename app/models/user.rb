class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  has_many :contest_registrations
  has_many :contests, through: :contest_registrations
  has_many :submissions

  def score_for_contest(contest_id)
    return 0 unless contest_id
    contest = Contest.find(contest_id)
    return 0 if contest.nil?
    return 0 unless contest.registered_by?(self)
    userid = id
    contest.data_sets.map { |ds| ds.user_score(userid) }.inject(:+)
  end
end
