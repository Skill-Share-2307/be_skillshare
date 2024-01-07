class Api::V1::SearchSkillsController < ApplicationController
  before_action :check_for_empty_query

  def index
    begin
      searched_users = SearchFacade.new(params).build_users
    rescue ActiveRecord::RecordNotFound
      render json: { error: "User could not be found" }, status: 404
    else
      render json: SearchedUserSerializer.new(searched_users)
    end
  end

  private

  # This is a placeholder method that could be used if we want to add additional filters
  # It would need to be used in the index method and replace the conditional that 
  # currently checks for the params[:is_remote]
  # def apply_filters(users)
  #   users = users.remote_users if params[:users]
  #   # Can add more filters after this to reduce the users array we get back.
  #   users
  # end

  def check_for_empty_query
    if params[:query].blank?
      render json: { error: "Please enter a skill to search for." }, status: 400
    end
  end
end
