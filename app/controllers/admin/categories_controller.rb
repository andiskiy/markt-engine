module Admin
  class CategoriesController < AdminController
    before_action :set_category, only: %i[show edit update destroy move_items update_items]
    before_action :set_new_category, only: %i[new create]
    before_action :set_authorize, only: %i[index new create]

    def index
      @categories = Category.search(params[:value])
                            .includes(:items)
                            .paginate(page: params[:page], per_page: Category::PER_PAGE)
      respond_to do |format|
        format.html {}
        format.js do
          render partial: 'admin/categories/categories', layout: false, locals: { categories: @categories }
        end
      end
    end

    def show; end

    def new; end

    def edit; end

    def create
      @category.assign_attributes(permit_params)
      respond_to do |format|
        if @category.save
          format.html { redirect_to(admin_categories_path) }
          format.json { render json: { status: :created, category: @category } }
        else
          format.html { render :new }
          format.json { render json: { errors: @category.errors, status: :unprocessable_entity } }
        end
      end
    end

    def update
      respond_to do |format|
        if @category.update(permit_params)
          format.html redirect_to admin_categories_path,
                                  flash: { success: t('admin.category.flash_messages.update.success') }
          format.json { render json: { status: :updated, category: @category } }
        else
          format.html render :edit,
                             flash: { danger: t('admin.category.flash_messages.update.danger') }
          format.json { render json: { errors: @category.errors, status: :unprocessable_entity } }
        end
      end
    end

    def destroy
      respond_to do |format|
        if @category.destroy
          format.html redirect_to admin_categories_path,
                                  flash: { success: t('admin.category.flash_messages.delete.success') }
          format.json { render json: { status: :deleted } }
        else
          format.html redirect_to admin_categories_path,
                                  flash: { danger: t('admin.category.flash_messages.delete.danger') }
          format.json { render json: { errors: @category.errors, status: :unprocessable_entity } }
        end
      end
    end

    def move_items
      @categories = Category.all.where.not(id: @category.id)
    end

    def update_items
      # TODO
      # move to Background task

      @category.items.update_all(category_id:      permit_params[:category_id],
                                 prev_category_id: @category.id)
      respond_to do |format|
        format.html do
          flash[:success] = t('admin.category.flash_messages.update_items.success', category: @category.name)
          redirect_to admin_categories_path
        end
        format.json { render json: { status: :updated, category: @category } }
      end
    end

    private

    def set_category
      @category = Category.find(params[:id] || params[:category_id])
      authorize([:admin, @category])
    end

    def set_new_category
      @category = Category.new
    end

    def set_authorize
      authorize([:admin, Category])
    end

    def permit_params
      params.require(:category).permit(:name, :description, :category_id)
    end
  end
end
