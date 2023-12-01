class Api::V1::UsersController < ApplicationController
  def show
    render json: UserSerializer.new(User.find(params[:id]))
  end

  def create
    user = User.create(user_params)
    if user.save
      render json: UserSerializer.new(user), status: :created
    else
      render json: {error: user.errors.full_messages.to_sentence}, status: :unprocessable_entity
    end 
  end


  private

  def user_params
    params.permit(:first_name, :last_name, :email, :address, :lat, :lon, :is_remote)
  end
end
