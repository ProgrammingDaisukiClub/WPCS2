class Problem < ApplicationRecord
  belongs_to :contest
  has_many :data_sets
  has_many :submissions, through: :data_sets

  def label_and_score(user_id)
    {
      data_sets: data_sets.map { |data_set| data_set.to_json_hash(user_id) }
    }
  end
end
