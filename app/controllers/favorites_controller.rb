# frozen_string_literal: true

class FavoritesController < ApplicationController
  before_action :authenticate_user!
  def index
    @favorite = Favorite.where(user_id: current_user.id)

  end

  def create
    @favorite = Favorite.new(offer_id: params[:offer_id], user_id: current_user.id)
    if @favorite.save
      render 'favorites/to_favorite'
    else
      redirect_back fallback_location: root_path, alert: 'Помилка'
    end
  end

  def destroy
    offer = Offer.find(params[:id])
    @favorite = Favorite.where(user_id: current_user.id, offer_id: offer.id).destroy_all
    render 'favorites/to_favorite'
  end
end
