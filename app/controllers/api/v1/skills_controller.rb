class Api::V1::SkillsController < ApplicationController
  def create
    begin
      user = User.find(params[:user_id])

      params[:skills].each do |skill_params|
        existing_skill = user.skills.find_by(name: skill_params[:name])

        if existing_skill
          render json: { error: "Skill '#{skill_params[:name]}' already exists for the user." }, status: :unprocessable_entity
          return
        end

        user.skills.create(name: skill_params[:name], proficiency: skill_params[:proficiency])
      end

      render json: UserSerializer.new(user), status: :created
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found.' }, status: :not_found
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
end
