class CartsController < ApplicationController
  before_action :authenticate_user!

 def index
  @orders = Purchase.find_by(user_id: current_user.id, completed: false).orders
 end

end