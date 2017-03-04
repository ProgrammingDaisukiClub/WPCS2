class Contest < ApplicationRecord
  has_many :problems
  has_many :data_sets, through: :problems
  has_many :submissions, through: :problems
  has_many :contest_registrations
  has_many :users, through: :contest_registrations

  def started?
    start_at < Time.now
  end

  def ended?
    end_at < Time.now
  end

  def during?
    started? && !ended?
  end

  def get_without_problems(lang)
    json_without_problems = {
      id: id,
      name: lang == 'ja' ? name_ja : name_en,
      description: lang == 'ja' ? description_ja : description_en
    }
  end

  def get_problems(lang)
    json_problems = { problems: problems.map do |problem|
                                  {
                                    id: problem.id,
                                    name: lang == 'ja' ? problem.name_ja : problem.name_en,
                                    description: lang == 'ja' ? problem.description_ja : problem.description_en,
                                    data_sets: problem.data_sets.map do |data_set|
                                      {
                                        id: data_set.id,
                                        label: data_set.label,
                                        score: data_set.score
                                      }
                                    end
                                  }
                                end }
  end

  def registered_by(user)
    ContestRegistration.find_by(user_id: user.id, contest_id: id).present?
  end

  def register(user)
    ContestRegistration.create(user_id: user.id, contest_id: id)
  end
end
