class Api::V1::SearchSkillsController < ApplicationController
  # before_action :searched_users, only: [:index]
  before_action :check_for_empty_query

  def index
    searched_users = SearchFacade.new(params).users
    # if params[:is_remote]
    #   render json: SearchedUserSerializer.new(@users.remote_users)
    # elsif !@users.empty?
    #   render json: SearchedUserSerializer.new(@users), status: 200
    # elsif searched_users.empty?
    #   render json: {data: []}, status: 200
    # end 
  end

 private

  #this is a placeholder method that could be used if we want to add additional filters
  #It woul dneed to be used in teh index method and replace the conditional that 
  #currently checks for the params[:is_remote]
  def apply_filters(users)
    users = users.remote_users if params[:users]
    #can add more filters after this to reduce the users array we get back. 
    users
  end

  # def searched_users 
  #   @users = User.search_for_skills(params[:query])
  # end

  def check_for_empty_query
    if params[:query].blank?
      render json: {error: "Please enter a skill to search for."}, status: 400
    end
  end
end