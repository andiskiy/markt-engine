class ItemsController < ApplicationController
  before_action :set_purchase

  def index
    set_categories
    @items = Item.search(params[:value], params[:category_id])
                 .includes(:item_photos, :orders)
                 .paginate(page: params[:page], per_page: Item::PER_PAGE)
    respond_to do |format|
      format.html {}
      format.js do
        render partial: 'partials/items', layout: false, locals: { items: @items, purchase: @purchase }
      end
    end
  end

  def show
    @item = Item.find(params[:id])
  end
end
