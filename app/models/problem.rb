class Problem < ApplicationRecord
  belongs_to :contest
  has_many :data_sets
  has_many :submissions, through: :data_sets

  def label_and_score(user_id)
    {
      data_sets: data_sets.map { |data_set| data_set.to_json_hash(user_id) }
    }
  end

  def label_score_solved_at(user_id)
    {
      data_sets: data_sets.map do |data_set|
        { id: data_set.id, label: data_set.label }.tap do |data|
          if data_set.solved_by?(user_id)
            data.merge(score: data_set.user_score(user_id), solved_at: data_set.user_solved_at(user_id))
          end
        end
      end
    }
  end

  def latest_accepted_submisson(user_id); end
end
