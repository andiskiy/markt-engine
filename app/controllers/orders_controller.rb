class OrdersController < ApplicationController
  before_action :authenticate_user!

  def create
    purchase = current_user.purchases.find_or_create_by(completed: false)
    Order.create(user_id: current_user.id, item_id: params[:item_id], purchase_id: purchase.id)
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