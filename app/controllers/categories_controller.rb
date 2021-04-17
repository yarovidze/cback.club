class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @offers = Offer.where(category_id: @category, ).paginate(page: params[:page], per_page: 16)
  end
end
