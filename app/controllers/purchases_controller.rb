class PurchasesController < ApplicationController
  before_action :authenticate_user!

  def update
    purchase = Purchase.find(params[:id])
    authorize(purchase)
    respond_to do |format|
      if purchase.processing!
        format.html { redirect_to root_path, flash: { success: t('cart.flash_messages.success') } }
        format.json { render status: :created, location: purchase }
      else
        format.html { redirect_to carts_path, flash: { danger: t('cart.flash_messages.danger') } }
        format.json { render errors: purchase.errors, status: :unprocessable_entity }
      end
    end
  end
end
