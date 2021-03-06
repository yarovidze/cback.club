class OffersController < ApplicationController
  def index
    @offers = Offer.where('name ILIKE ?', "%#{params[:query]}%").paginate(page: params[:page], per_page: 16)
    respond_to do |format|
      format.html
      format.json { render json: @offers.map(&:name) }
    end
   
  end

  def search
    @offers = Offer.where('name ILIKE ?', "%#{params[:query]}%").paginate(page: params[:page], per_page: 16)
    render "offers/index"
  end

  def autocomplete
    render json: Offer.all.map(&:name)
  end


  def show
    @offer = Offer.find(params[:id])
  end
end
