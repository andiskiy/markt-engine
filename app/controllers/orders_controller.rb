class OrdersController < ApplicationController
  before_action :authenticate_user!

  def create
    purchase = current_user.purchases.find_or_create_by(status: 'pending')
    order = Order.find_or_initialize_by(user_id:     current_user.id,
                                        item_id:     params[:item_id],
                                        purchase_id: purchase.id)
    respond_to do |format|
      if order.increase!
        format.html { redirect_to carts_path, flash: { success: t('cart.flash_messages.create.success') } }
        format.json { render json: { status: :created, order: order } }
      else
        format.html { redirect_to carts_path, flash: { danger: t('cart.flash_messages.create.danger') } }
        format.json { render json: { errors: order.errors, status: :unprocessable_entity } }
      end
    end
  end

  def destroy
    order = Order.find(params[:id])
    respond_to do |format|
      if order.destroy
        format.html { redirect_to carts_path, flash: { success: t('cart.flash_messages.delete.success') } }
        format.json { render json: { status: :deleted } }
      else
        format.html { redirect_to carts_path, flash: { danger: t('cart.flash_messages.delete.danger') } }
        format.json { render json: { errors: order.errors, status: :unprocessable_entity } }
      end
    end
  end
end
