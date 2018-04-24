class Contest < ApplicationRecord
  has_many :problems, -> { order(:order) }, dependent: :destroy
  has_many :data_sets, through: :problems
  has_many :submissions, through: :data_sets
  has_many :contest_registrations, dependent: :destroy
  has_many :users, through: :contest_registrations
  has_one  :editorial, dependent: :destroy

  enum status: {
      outside: 0,
      inside: 1
  }

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

  def show_without_problems(joined, current_user)
    {
      id: id,
      name: name,
      description: description,
      start_at: start_at,
      end_at: end_at,
      baseline: score_baseline,
      current_user_id: current_user.try(:id),
      joined: joined,
      admin_role: current_user.try(:admin_role).present?
    }
  end

  def show_with_problems(joined, current_user)
    show_without_problems(joined, current_user).merge(
      problems: problems.map do |problem|
        {
          id: problem.id,
          name: problem.name,
          description: problem.description,
          data_sets: data_set_for_show(current_user, problem.data_sets)
        }
      end
    )
  end

  def data_set_for_show(current_user, data_sets)
    data_sets.order(order: :asc).map do |data_set|
      {
        id: data_set.id,
        label: data_set.label,
        max_score: data_set.score,
        correct: data_set.solved_by?(current_user),
        score: data_set.user_score(current_user)
      }
    end
  end

  def show_with_problems_and_editorial(joined, current_user)
    show_with_problems(joined, current_user).merge(editorial: editorial)
  end

  def registered_by?(user)
    ContestRegistration.find_by(user: user, contest: self).present?
  end

  def register(user)
    ContestRegistration.create(user: user, contest: self)
  end

  def sorted_users
    users.sort { |user1, user2| user_score(user2) <=> user_score(user1) }
  end

  def user_score(user)
    return 0 unless user && registered_by?(user)
    data_sets.map { |data_set| data_set.user_score(user) }.inject(0, :+)
  end
end
