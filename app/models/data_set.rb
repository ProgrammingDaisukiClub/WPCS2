class DataSet < ApplicationRecord
  belongs_to :problem
  has_many :submissions
end
