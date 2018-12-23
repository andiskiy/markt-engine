class ItemsController < ApplicationController
  def index
    @items = Item.search(params[:value], params[:category_id])
                 .includes(:item_photos)
                 .paginate(page: params[:page], per_page: Item::PER_PAGE)
    render partial: 'partials/items', layout: false, locals: { items: @items }
  end
end
