class Contest < ApplicationRecord
  has_many :problems
  has_many :data_sets, through: :problems
  has_many :submissions, through: :problems
  has_many :contest_registrations
  has_many :users, through: :contest_registrations

  def started?
    self.start_at < Time.now
  end

  def ended?
    self.end_at < Time.now
  end

  def registered_by(user)
    ContestRegistration.find_by(user_id: user.id, contest_id: self.id).present?
  end
end
