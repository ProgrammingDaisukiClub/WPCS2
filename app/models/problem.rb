class Problem < ApplicationRecord
  belongs_to :contest
  has_many :data_sets
  has_many :submissions, through: :data_sets

  def label_and_score
    {
      data_sets: data_sets.map do |data_set|
        {
          id: data_set.id,
          label: data_set.label,
          score: data_set.score
        }
      end
    }
  end

  def label_score_solvedat
    {
      data_sets: data_sets.map do |data_set|
        {
          id: data_set.id,
          label: data_set.label,
          score: data_set.score,
          solved_at: data_set.solved_at
        }
      end
    }
  end
end
