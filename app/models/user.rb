class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  validates :student_id, presence: true, length: { is: 8 }

  has_many :contest_registrations
  has_many :contests, through: :contest_registrations
  has_many :submissions
  has_one :admin_role
end
