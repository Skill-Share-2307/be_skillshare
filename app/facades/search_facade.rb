class SearchFacade
  def initialize(params)
    @is_remote = params[:is_remote]
    @user_id = params[:user_id]
    @query = params[:query]
  end

  def build_users
    users = User.search_for_skills(@query)
    users = users.remote_users if @is_remote
    users.map { |user| SearchedUserPoro.new(user) }
  end
end