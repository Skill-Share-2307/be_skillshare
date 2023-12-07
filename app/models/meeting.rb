class Meeting < ApplicationRecord
  validates :date, :start_time, :end_time, :purpose, presence: true
  has_many :user_meetings
  has_many :users, through: :user_meetings

  def partner_id
    user_meetings.find_by(is_requestor: false).user_id
  end

  def host_id
    user_meetings.find_by(is_requestor: true).user_id
  end

  def get_attendee(user_id)
    user_meetings.where.not("user_meetings.user_id = ?", user_id).pluck(:user_id).first
  end
end
