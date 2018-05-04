module Admin
  class ItemsController < AdminController

    def index
      @items = Item.all
    end

    def new
      @item = Item.new
    end

    def create
      @item = Item.create(permit_params)
      redirect_to admin_items_path
    end

    private

    def permit_params
      params.require(:item).permit(:name, :description, :price, :category_id)
    end
  end
end