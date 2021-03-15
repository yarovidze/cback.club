class FavoritesController < ApplicationController

  def index
    @favorite = current_user.favorite
  end

  def create
    @favorite = Favorite.new(offer_id: params[:offer_id], user_id: current_user)
    if @favorite.save
      redirect_back fallback_location: root_path, notice: 'Added to favorite'
    else
      redirect_back fallback_location: root_path, notice: 'Error'
      puts "_-----------------------------------"
      puts current_user.id
      puts current_user
      puts params[:offer_id]
    end
  end

  def destroy
    offer = Offer.find(params[:id])
    @favorite = Favorite.where(user_id: current_user.id, offer_id: offer.id).first
    redirect_back fallback_location: root_path, notice: 'Deleted from favorite'
  end

end

