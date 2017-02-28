class Contest < ApplicationRecord
  has_many :problems
  has_many :data_sets, through: :problems
  has_many :submissions, through: :problems
  has_many :contest_registrations
  has_many :users, through: :contest_registrations
end
