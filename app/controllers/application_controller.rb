class ApplicationController < ActionController::Base
  #before_action :authenticate_user!
  helper_method :current_favorite

  def current_favorite
    Favorite.find_by(user_id: current_user.id)
  end

end
