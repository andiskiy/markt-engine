class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_purchase

  def create
    order = Order.find_or_initialize_by(user_id:     current_user.id,
                                        item_id:     params[:item_id],
                                        purchase_id: @purchase.id)
    respond_to do |format|
      if order.increase!
        format.html { redirect_to carts_path, flash: { success: t('cart.flash_messages.create.success') } }
        format.json { render json: { status: :created, order: order, purchase: { amount: @purchase.amount_items } } }
      else
        format.html { redirect_to carts_path, flash: { danger: t('cart.flash_messages.create.danger') } }
        format.json { render json: { errors: order.errors, status: :unprocessable_entity } }
      end
    end
  end

  def destroy
    order = Order.find(params[:id])
    respond_to do |format|
      format.html do
        if order.destroy
          flash[:success] = t('cart.flash_messages.delete.success')
        else
          flash[:danger] = t('cart.flash_messages.delete.danger')
        end
        redirect_to(carts_path)
      end
      format.json do
        if order.decrease!
          render json: { status: :deleted, order: order, purchase: { amount: @purchase.amount_items } }
        else
          render json: { errors: order.errors, status: :unprocessable_entity }
        end
      end
    end
  end
end
