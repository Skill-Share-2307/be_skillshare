class User < ApplicationRecord
  validates :first_name, :last_name, :address, :lat, :lon, :is_remote, presence: true
  validates :email, presence: true, uniqueness: true
  has_many :user_meetings
  has_many :meetings, through: :user_meetings
end
