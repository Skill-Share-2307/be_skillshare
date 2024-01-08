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

  def check_for_empty_query
    if params[:query].blank?
      render json: { error: "Please enter a skill to search for." }, status: 400
    end
  end
end
