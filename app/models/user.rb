class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  has_many :user_meetings
  has_many :meetings, through: :user_meetings
end
