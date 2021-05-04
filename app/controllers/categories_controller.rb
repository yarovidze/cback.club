class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @offers = @category.offers.paginate(page: params[:page], per_page: 16)
  end
end
