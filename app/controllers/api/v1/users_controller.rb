class Api::V1::UsersController < ApplicationController
  def show
    begin
      user = User.find(params[:id])
      render json: UserSerializer.new(user)
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found.' }, status: :not_found
    end
  end
end
