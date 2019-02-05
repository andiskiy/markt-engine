module Admin
  class ItemsController < AdminController
    before_action :set_category, except: :all_items
    before_action :set_item, only: %i[show edit update destroy]
    before_action :set_new_item, only: %i[new create]

    def all_items
      @items = Item.search(params[:value], params[:category_id])
                   .includes(:category)
                   .paginate(page: params[:page], per_page: Item::PER_PAGE)
      respond_to do |format|
        format.html {}
        format.js do
          render partial: 'admin/items/items_table', layout: false, locals: { items: @items }
        end
      end
    end

    def index
      @items = @category.items.paginate(page: params[:page], per_page: Item::PER_PAGE)
      respond_to do |format|
        format.html {}
        format.js do
          render partial: 'admin/categories/items', layout: false, locals: { category:  @category,
                                                                             items:     @items,
                                                                             next_page: params[:page].to_i + 1 }
        end
      end
    end

    def show; end

    def new
      @item.item_photos.build
    end

    def edit; end

    def create
      @item.assign_attributes(permit_params)
      respond_to do |format|
        if @item.save
          format.html { redirect_to(admin_category_items_path(@category)) }
          format.json { render json: { status: :created, items: @category.items } }
        else
          format.html { render :new }
          format.json { render json: @item.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @item.update(permit_params)
          format.html { redirect_to(admin_category_items_path(@category)) }
          format.json { render json: { status: :created, items: @category.items } }
        else
          format.html { render :edit }
          format.json { render json: @item.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      if @item.destroy
        flash[:success] = t('admin.item.flash_messages.delete.success')
      else
        flash[:danger] = t('admin.item.flash_messages.delete.danger')
      end
      redirect_to(admin_category_items_path(@category))
    end

    private

    def set_category
      @category = Category.find(params[:category_id])
    end

    def set_item
      @item = Item.find(params[:id])
    end

    def set_new_item
      @item = @category.items.new
    end

    def permit_params
      params.require(:item).permit(:name, :description, :price, :category_id, item_photos_attributes: [:photo])
    end
  end
end
