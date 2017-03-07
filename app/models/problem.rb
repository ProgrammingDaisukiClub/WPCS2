class Problem < ApplicationRecord
  belongs_to :contest
  has_many :data_sets
  has_many :submissions, through: :data_sets

  def label_and_score(user_id)
    {
      data_sets: data_sets.map do |data_set|
        {
          id: data_set.id,
          label: data_set.label,
          max_score: data_set.score,
          correct: data_set.solved_by?(user_id),
          score: data_set.user_score(user_id)
        }
      end
    }
  end
end
