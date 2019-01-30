module Admin
  class ItemsController < AdminController
    before_action :set_new_item

    def index
      @items = Item.all
    end

    def new
      @item.item_photos.build
    end

    def create
      @item.assign_attributes(permit_params)
      @item.save ? redirect_to(admin_items_path) : render(:new)
    end

    private

    def set_new_item
      @item = Item.new
    end

    def permit_params
      params.require(:item).permit(:name, :description, :price, :category_id, item_photos_attributes: [:photo])
    end
  end
end
