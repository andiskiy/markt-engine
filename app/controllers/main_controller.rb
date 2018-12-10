class MainController < ApplicationController
  def index
    @categories = Category.all
    @items = Item.all.includes(:item_photos)
  end
end
