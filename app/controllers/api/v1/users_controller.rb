class Api::V1::UsersController < ApplicationController

  def index
    users = User.all
    render json: UserSerializer.new(users)
  end

  def show
    begin
      user = User.find(params[:id])
      render json: UserSerializer.new(user)
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found.' }, status: :not_found
    end
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
    params.permit(:first_name, :last_name, :email, :lat, :lon, :is_remote, :about, :city, :state, :zipcode, :street)
  end
end
