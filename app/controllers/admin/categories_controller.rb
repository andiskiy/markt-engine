module Admin
  class CategoriesController < AdminController

    def index
      @categories = Category.all
    end

    def new
      @category = Category.new
    end

    def create
      @category = Category.create(permit_params)
      @category.save
      redirect_to admin_categories_path
    end

    private

    def permit_params
      params.require(:category).permit(:name, :description)
    end

  end
end