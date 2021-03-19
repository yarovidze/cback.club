# frozen_string_literal: true
class OffersController < ApplicationController
  before_action :find_offer, only: %i[show offer_redirect]
  def index
    @offers = Offer.where('name ILIKE ?', "%#{params[:query]}%").paginate(page: params[:page], per_page: 16)
    respond_to do |format|
      format.html
      format.json { render json: @offers.map(&:name) }
    end
    # test--------------------------------
    autorisation_admitad
    get_subid_data
    rec_user_data if cookies[:subid_data].present?
  end

  def redirect
    redirect_to @offer.link_to_offer(@offer.link, current_user.id)
  end

  def search
    @offers = Offer.where('name ILIKE ?', "%#{params[:query]}%").paginate(page: params[:page], per_page: 16)
    render 'offers/index'
  end

  def autocomplete
    render json: Offer.all.map(&:name)
  end

  def show; end

  private

  def find_offer
    @offer = Offer.find(params[:id])
  end
end
