class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @offers = Offer.where(category_id: @category.id).where('name ILIKE ?  OR alt_name ILIKE ?', "%#{params[:query]}%", "%#{params[:query]}%").paginate(page: params[:page], per_page: 16)
  end
end
