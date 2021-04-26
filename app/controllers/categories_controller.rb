class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @offers = Offer.where(category_id: @category).paginate(page: params[:page], per_page: 16)
    flash.now[:alert] = 'Категорія порожня. Спробуйте пізніше.' if @offers.blank?
  end
end
