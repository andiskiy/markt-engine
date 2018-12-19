class CategoriesController < ApplicationController
  before_action :set_categories

  def show
    @category = Category.find(params[:id])
  end

  private

  def set_categories
    @categories = Category.all
  end
end
