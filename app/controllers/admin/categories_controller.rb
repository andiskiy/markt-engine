module Admin
  class CategoriesController < AdminController
    before_action :set_category, only: %i[edit update destroy]

    def index
      @categories = Category.all
    end

    def new
      @category = Category.new
    end

    def edit; end

    def create
      @category = Category.new(permit_params)
      @category.save
      redirect_to(admin_categories_path)
    end

    def update
      @category.update(permit_params)
      redirect_to(admin_categories_path)
    end

    def destroy
      @category.destroy
      redirect_to(admin_categories_path)
    end

    private

    def permit_params
      params.require(:category).permit(:name, :description)
    end

    def set_category
      @category = Category.find(params[:id])
    end
  end
end
