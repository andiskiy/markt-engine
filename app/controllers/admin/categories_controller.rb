module Admin
  class CategoriesController < AdminController
    before_action :set_category, only: %i[show edit update destroy]
    before_action :set_new_category, only: %i[new create]

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
          format.json { render json: { status: :created, categories: Category.all } }
        else
          format.html { render :new }
          format.json { render json: @category.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @category.update(permit_params)
          format.html { redirect_to(admin_categories_path) }
          format.json { render json: { status: :updated, categories: Category.all } }
        else
          format.html { render :edit }
          format.json { render json: @category.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      if @category.destroy
        flash[:success] = t('admin.category.flash_messages.delete.success')
      else
        flash[:danger] = t('admin.category.flash_messages.delete.danger')
      end
      redirect_to(admin_categories_path)
    end

    private

    def set_category
      @category = Category.find(params[:id])
    end

    def set_new_category
      @category = Category.new
    end

    def permit_params
      params.require(:category).permit(:name, :description)
    end
  end
end
