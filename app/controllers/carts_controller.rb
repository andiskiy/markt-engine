class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_purchase

  def index
    @orders = @purchase.orders.joins(:item)
  end
end
