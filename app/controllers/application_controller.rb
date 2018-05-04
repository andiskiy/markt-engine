class ApplicationController < ActionController::Base
  before_action :set_category


  private

  def set_category
    @category = Category.all
  end

  def admin_user!
    redirect_to root_path unless current_user.role == 0
  end
end
