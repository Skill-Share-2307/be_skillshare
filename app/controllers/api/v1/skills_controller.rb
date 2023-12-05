class Api::V1::SkillsController < ApplicationController

  def create
    user = User.find(params[:user_id])
    params[:skills].each do |skill|
      user.skills.create(name: skill[:name], proficiency: skill[:proficiency] )
    end

    render json: UserSerializer.new(user)
  end
end