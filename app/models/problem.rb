class Problem < ApplicationRecord
  belongs_to :contest
  has_many :data_sets, dependent: :destroy
  has_many :submissions, through: :data_sets

  def name
    send("name_#{I18n.locale}")
  end

  def description
    send("description_#{I18n.locale}")
  end

  def label_and_score(user)
    {
      data_sets: data_sets.order(order: :asc).map { |data_set| data_set.to_json_hash(user.id) }
    }
  end
end
