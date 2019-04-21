class CategoriesController < ApplicationController
  before_action :set_categories
  before_action :set_purchase

  def show
    @category = Category.find(params[:id])
    @items = @category.items.includes(:item_photos).paginate(page: params[:page], per_page: Item::PER_PAGE)
  end
end
