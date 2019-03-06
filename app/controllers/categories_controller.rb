class CategoriesController < ApplicationController
  def show
    set_categories
    set_purchase
    @category = Category.find(params[:id])
    @items = @category.items.includes(:item_photos).paginate(page: params[:page], per_page: Item::PER_PAGE)
  end
end
