class Api::V1::SearchSkillsController < ApplicationController
  before_action :searched_users, only: [:index]
  before_action :check_for_empty_query

  def index
    if !@users.empty?
      render json: SearchedUserSerializer.new(@users), status: 200
    elsif searched_users.empty?
      render json: {data: []}, status: 200
    end 
  end

 private

  def searched_users 
    @users = User.search_for_skills(params[:query])
  end

  def check_for_empty_query
    if params[:query].blank?
      render json: {error: "Please enter a skill to search for."}, status: 400
    end
  end

end