class OffersController < ApplicationController
  def index
    @offers = Offer.where('name ILIKE ?', "%#{params[:q]}%").paginate(page: params[:page], per_page: 16)
  end


 
  def show
    @offer = Offer.find(params[:id])
  end
end
