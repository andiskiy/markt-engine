module Admin
  class ItemsController < AdminController
    before_action :set_category, except: :all_items
    before_action :set_item, only: %i[show edit update destroy]
    before_action :set_new_item, only: %i[new create]
    before_action :item_photos_build, only: %i[new edit]

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

    def new; end

    def edit; end

    def create
      @item.assign_attributes(permit_params)
      respond_to do |format|
        if @item.save
          format.html do
            flash[:success] = t('admin.item.flash_messages.create.success')
            redirect_to admin_category_items_path(@category)
          end
          format.json { render json: { status: :created, item: @item } }
        else
          @item.ensure_five_photos
          format.html do
            flash[:danger] = t('admin.item.flash_messages.create.danger')
            render :new
          end
          format.json { render json: { errors: @item.errors, status: :unprocessable_entity } }
        end
      end
    end

    def update
      respond_to do |format|
        if @item.update(permit_params)
          format.html do
            flash[:success] = t('admin.item.flash_messages.update.success')
            redirect_to admin_category_items_path(@category)
          end
          format.json { render json: { status: :updated, item: @item } }
        else
          @item.ensure_five_photos
          format.html do
            flash[:danger] = t('admin.item.flash_messages.update.danger')
            render :edit
          end
          format.json { render json: { errors: @item.errors, status: :unprocessable_entity } }
        end
      end
    end

    def destroy
      respond_to do |format|
        if @item.destroy
          format.html do
            flash[:success] = t('admin.item.flash_messages.delete.success')
            redirect_to admin_category_items_path(@category)
          end
          format.json { render json: { status: :deleted } }
        else
          format.html do
            flash[:danger] = t('admin.item.flash_messages.delete.danger')
            redirect_to admin_category_items_path(@category)
          end
          format.json { render json: { errors: @item.errors, status: :unprocessable_entity } }
        end
      end
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

    def item_photos_build
      @item.ensure_five_photos
    end

    def permit_params
      params.require(:item).permit(:name, :description, :price, :category_id,
                                   item_photos_attributes: %i[id remove_photo photo active
                                                              photo_cache remove_photo])
    end
  end
end
