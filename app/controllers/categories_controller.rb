class CategoriesController < ApplicationController


  def show
    @items = Category.find(params[:id]).items
  end

end