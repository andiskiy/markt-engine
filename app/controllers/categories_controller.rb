class CategoriesController < ApplicationController
  def show
    @categories = Category.all
    category = Category.find(params[:id])
    @items = category.items
    @category_name = category.name
  end
end
