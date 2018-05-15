class CartsController < ApplicationController
  before_action :authenticate_user!

 def index
  @purchase = Purchase.find_by(user_id: current_user.id, completed: false)
  @orders = @purchase.orders
 end

end