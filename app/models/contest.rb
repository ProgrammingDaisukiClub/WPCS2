class Contest < ApplicationRecord
  has_many :problems, -> { order(:order) }, dependent: :destroy
  has_many :data_sets, through: :problems
  has_many :submissions, through: :data_sets
  has_many :contest_registrations, dependent: :destroy
  has_many :users, through: :contest_registrations
  has_one  :editorial, dependent: :destroy

  def name
    send("name_#{I18n.locale}")
  end

  def description
    send("description_#{I18n.locale}")
  end

  def preparing?
    start_at > Time.current
  end

  def started?
    start_at < Time.current
  end

  def ended?
    end_at < Time.current
  end

  def during?
    started? && !ended?
  end

  def editorial?
    !editorial.nil?
  end

  def registered_by?(user)
    ContestRegistration.find_by(user: user, contest: self).present?
  end

  def register(user)
    ContestRegistration.create(user: user, contest: self)
  end

  def sorted_users
    users.sort { |user1, user2| @contest.user_score(user2) <=> user_score(user1) }
  end

  def user_score(user)
    return 0 unless user && registered_by?(user)
    data_sets.map { |data_set| data_set.user_score(user) }.inject(0, :+)
  end
end
