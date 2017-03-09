class Contest < ApplicationRecord
  has_many :problems
  has_many :data_sets, through: :problems
  has_many :submissions, through: :problems
  has_many :contest_registrations
  has_many :users, through: :contest_registrations

  scope :id_is, ->(id) { where(id: id) }

  def started?
    start_at < Time.now
  end

  def ended?
    end_at < Time.now
  end

  def during?
    started? && !ended?
  end

  def name_and_description(lang)
    {
      id: id,
      name: lang == 'ja' ? name_ja : name_en,
      description: lang == 'ja' ? description_ja : description_en,
      start_at: start_at,
      end_at: end_at
    }
  end

  def problems_to_show(user_id, lang)
    {
      problems: problems.map do |problem|
        {
          id: problem.id,
          name: lang == 'ja' ? problem.name_ja : problem.name_en,
          description: lang == 'ja' ? problem.description_ja : problem.description_en
        }.merge(problem.label_and_score(user_id))
      end
    }
  end

  def problems_for_ranking
    {
      problems: problems.map do |problem|
        {
          id: problem.id
        }.merge(problem.label_score_solvedat)
      end
    }
  end

  def registered_by?(user)
    ContestRegistration.find_by(user_id: user.id, contest_id: id).present?
  end

  def register(user)
    ContestRegistration.create(user_id: user.id, contest_id: id)
  end

  def ranking
    users = User.registered_contest_id(id)
  end
end
