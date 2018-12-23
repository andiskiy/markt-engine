class MainController < ApplicationController
  before_action :set_categories

  def index
    @items = Item.all.includes(:item_photos).paginate(page: params[:page], per_page: Item::PER_PAGE)
  end

  private

  def set_categories
    @categories = Category.all
  end
end
