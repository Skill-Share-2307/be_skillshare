class SearchFacade
  def initialize(params)
    @is_remote = params[:is_remote] == "true" ? true : false
    @current_user_id = params[:user_id]
    @query = params[:query]
  end

  def build_users
    searched_users = User.search_for_skills(@query)
    searched_users = searched_users.remote_users if @is_remote
    current_user = User.find(@current_user_id)

    searched_users.map { |searched_user| SearchedUserPoro.new(searched_user, current_user) }
  end
end