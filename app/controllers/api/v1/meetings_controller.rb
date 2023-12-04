class Api::V1::MeetingsController < ApplicationController
  before_action :set_users, only: [:create]
  before_action :existing_partner_check, only: [:create]

  def create
    user = @users[:user]
    partner = @users[:partner]

    meeting = Meeting.create(meeting_params)

    if meeting.save
      UserMeeting.create(user: user, meeting: meeting, is_requestor: true)
      UserMeeting.create(user: partner, meeting: meeting, is_requestor: false)
      render json: MeetingSerializer.new(meeting), status: :created
    else
      render json: { error: meeting.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def update
    meeting = Meeting.find_by(id: params[:id])

    if meeting.nil?
      render json: { error: 'Meeting not found.' }, status: :not_found
    else
      if params[:is_approved] == "true"
        meeting.update(is_accepted: true)
        render json: { success: 'Meeting updated successfully.' }
      elsif params[:is_approved] == "false"
        meeting.update(is_accepted: true)
        render json: { success: 'Meeting updated successfully.' }
      else
        render json: { error: 'Invalid parameter value for is_approved.' }, status: :unprocessable_entity
      end
    end
  end

  private

  def set_users
    @users = {
      user: User.find_by(id: params[:user_id]),
      partner: User.find_by(id: params[:partner_id])
    }
  end

  def existing_partner_check
    if @users[:partner].nil?
      render json: { error: 'Partner not found.' }, status: :not_found
    end
  end 

  def meeting_params
    params.permit(:date, :start_time, :end_time, :is_accepted, :purpose)
  end
end
