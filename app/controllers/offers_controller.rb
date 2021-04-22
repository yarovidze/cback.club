# frozen_string_literal: true
class OffersController < ApplicationController
  before_action :find_offer, only: [:offer_redirect, :show]

  def index
    @offers_rand = Offer.order('RANDOM()').limit(8)
    @offers = Offer.all.paginate(page: params[:page], per_page: 8)
    respond_to do |format|
      format.html
      format.json { render json: @offers.map(&:name) }
    end
    autorisation_admitad
    get_action_data
    rec_user_actions if cookies[:action_data].present?
  end

  def offer_redirect
    redirect_to  "#{@offer.link}/?subid=#{current_user.id}".to_s
  end

  def autocomplete
    render json: Offer.all.map(&:alt_name)
  end

  def search
    @offers = Offer.where('name ILIKE ?  OR alt_name ILIKE ?', "%#{params[:query]}%", "%#{params[:query]}%").paginate(
      page: params[:page], per_page: 16
    )
    render :index
  end

  def show
    @offer = Offer.friendly.find(params[:id])
    @category = Category.find(@offer.category_id)
    @related_offers = Offer.where.not(name: @offer.name).order('RANDOM()').limit(8)
  end

  private

  def find_offer
    @offer = Offer.friendly.find(params[:id])
  end
end
