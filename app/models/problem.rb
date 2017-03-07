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
end
