class Problem < ApplicationRecord
  belongs_to :contest
  has_many :data_sets, -> { order(:order) }, dependent: :destroy
  has_many :submissions, through: :data_sets

  def name
    send("name_#{I18n.locale}")
  end

  def description
    send("description_#{I18n.locale}")
  end
end
