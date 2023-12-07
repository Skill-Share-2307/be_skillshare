class Api::V1::Users::MeetingsController < ApplicationController
  def index
    begin
      user = User.find(params[:user_id])
      meetings = user.meetings.map {|meeting| MeetingPoro.new(meeting, user.id)}
      render json: MeetingSerializer.new(meetings)
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found.' }, status: :not_found
    end
  end
end
