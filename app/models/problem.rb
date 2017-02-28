class Problem < ApplicationRecord
  belongs_to :contest
  has_many :data_sets
  has_many :submissions, through: :data_sets
end
