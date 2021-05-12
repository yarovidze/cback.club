# frozen_string_literal: true

class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_offer, only: %i[create destroy]
  def index
    @favorite = Favorite.where(user_id: current_user.id)
  end

  def create
    @favorite = @offer_edited.favorites.new(user_id: current_user.id)
    if @favorite.save
      render 'favorites/to_favorite'
    else
      redirect_back fallback_location: root_path, alert: 'Помилка'
    end
  end

  def destroy
    @favorite = @offer_edited.favorites.where(user_id: current_user.id).destroy_all
    render 'favorites/to_favorite'
  end

  private

  def find_offer
    @offer_edited = Offer.find(params[:id])
  end
end
