class User < ApplicationRecord
  validates :first_name, :last_name, :address, :lat, :lon, presence: true
  validates :is_remote, inclusion: { in: [true, false] }
  validates :email, presence: true, uniqueness: true
  has_many :user_meetings
  has_many :meetings, through: :user_meetings
  has_many :skills
end
