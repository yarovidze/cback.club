class FavoritesController < ApplicationController

  def index
    @favorite = Favorite.where(user_id: current_user.id)
  end

  def create
    @favorite = Favorite.new(offer_id: params[:offer_id], user_id: current_user.id)
    if @favorite.save
      redirect_back fallback_location: root_path, notice: 'Додано в обране'
    else
      redirect_back fallback_location: root_path, notice: 'Помилка'
    end
  end

  def destroy
    offer = Offer.find(params[:id])
    @favorite = Favorite.where(user_id: current_user.id, offer_id: offer.id).destroy_all
    redirect_back fallback_location: root_path, notice: 'Видалено з обраного'
  end

end

