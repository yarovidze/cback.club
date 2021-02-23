class OffersController < ApplicationController
  def index
    @offers = Offer.all
  end

  def show
  end
end
