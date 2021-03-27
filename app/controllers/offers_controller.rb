# frozen_string_literal: true

class OffersController < ApplicationController
  def index
    @offers = Offer.where('name ILIKE ?  OR alt_name ILIKE ?', "%#{params[:query]}%", "%#{params[:query]}%").paginate(
      page: params[:page], per_page: 16
    )
    respond_to do |format|
      format.html
      format.json { render json: @offers.map(&:name) }
    end
    autorisation_admitad
    get_action_data
    #get_subid_data
    rec_user_actions if cookies[:action_data].present?
  end

  def offer_redirect
    @offer = Offer.find(params[:id])
    redirect_to  "#{@offer.link}/?subid=#{current_user.id}".to_s
  end

  def autocomplete
    render json: Offer.all.map(&:alt_name)
  end

  def show
    @offer = Offer.find(params[:id])
  end
end
