class Api::V1::Users::MeetingsController < ApplicationController
  def index
    begin
      user = User.find(params[:user_id])
      render json: UserMeetingsSerializer.new(user)
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found.' }, status: :not_found
    end
  end
end
