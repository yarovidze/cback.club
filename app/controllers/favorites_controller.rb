# frozen_string_literal: true

class FavoritesController < ApplicationController
  def index
    @favorite = Favorite.where(user_id: current_user.id)
  end

  def create
    @favorite = Favorite.new(offer_id: params[:offer_id], user_id: current_user.id)
    if @favorite.save
      render 'favorites/to_favorite'
    else
      redirect_back fallback_location: root_path, notice: 'Error'
    end
  end

  def destroy
    offer = Offer.find(params[:id])
    @favorite = Favorite.where(user_id: current_user.id, offer_id: offer.id).destroy_all
    if params[:from_favorites_list]
      respond_to do |format|
        format.js { render 'favorites/to_favorite' }
        end
    else
      render 'favorites/to_favorite'
    end
  end
end
