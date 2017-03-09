class Problem < ApplicationRecord
  belongs_to :contest
  has_many :data_sets
  has_many :submissions, through: :data_sets

  def label_and_score(user_id)
    {
      data_sets: data_sets.map { |data_set| data_set.to_json_hash(user_id) }
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
