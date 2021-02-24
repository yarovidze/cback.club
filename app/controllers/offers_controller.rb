class OffersController < ApplicationController
  def index
    @offers = Offer.all
    @offers = Offer.paginate(page: params[:page], per_page: 16)
  end

  def show
  end
end
