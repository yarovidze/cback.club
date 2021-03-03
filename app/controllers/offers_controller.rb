class OffersController < ApplicationController
  def index
    @offers = Offer.all
    @offers = Offer.paginate(page: params[:page], per_page: 16)
  end

  def search
    @offers = Offer.where('name ILIKE ?', "%#{params[:q]}%").paginate(page: params[:page], per_page: 16)
    render :index
  end

  def show
    @offer = Offer.find(params[:id])
  end
end
