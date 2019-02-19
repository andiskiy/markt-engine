class ItemsController < ApplicationController
  before_action :set_categories

  def index
    @items = Item.search(params[:value], params[:category_id])
                 .includes(:item_photos)
                 .paginate(page: params[:page], per_page: Item::PER_PAGE)
    respond_to do |format|
      format.html {}
      format.js do
        render partial: 'partials/items', layout: false, locals: { items: @items }
      end
    end
  end

  private

  def set_categories
    @categories = Category.all
  end
end
