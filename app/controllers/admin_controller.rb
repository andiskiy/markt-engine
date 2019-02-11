class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user!

  private

  def set_layout
    request.xhr? ? false : 'admin'
  end
end
