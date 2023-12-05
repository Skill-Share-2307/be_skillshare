class Api::V1::SkillsController < ApplicationController

  def create
    begin
      user = User.find(params[:user_id])

      params[:skills].each do |skill|
        user.skills.create(name: skill[:name], proficiency: skill[:proficiency] )
      end
      render json: UserSerializer.new(user), status: 201
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found.' }, status: :not_found
    end
  end
end