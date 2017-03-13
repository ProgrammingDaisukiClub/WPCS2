class Submission < ApplicationRecord
  belongs_to :user
  belongs_to :data_set

  delegate :problem_id, to: :data_set

  enum judge_status: {
    waiting: 0,
    wrong: 1,
    accepted: 2
  }, _prefix: true

  enum language: {
  }, _prefix: true
end
