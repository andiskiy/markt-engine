class OrdersController < ApplicationController
  before_action :authenticate_user!

  def create
    purchase = Purchase.where(user_id: current_user.id, completed: false)
    purchase = purchase.any? ? purchase.first : Purchase.create(user_id: current_user.id, completed: false)

    puts "--=====#{purchase}"

    order = Order.create(user_id: current_user.id, item_id: params[:item_id], purchase_id: purchase.id)
    puts "-------#{order.errors.messages}"
    redirect_to :carts
  end

  def destroy
    Order.delete(params[:id])
    redirect_to :carts
  end

  private

  def permit_params
    params.require(:order).permit(:item_id, :purchase_id, :user_id)
  end


end