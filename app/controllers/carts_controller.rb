class CartsController < ApplicationController
  before_action :authenticate_user!

  def index
    @purchase = current_user.purchases.find_or_create_by(status: 'pending')
    @orders = @purchase.orders
  end
end
