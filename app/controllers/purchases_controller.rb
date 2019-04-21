class PurchasesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_purchase

  def edit; end

  def update
    respond_to do |format|
      if @purchase.update(permit_params)
        format.html { redirect_to root_path, flash: { success: t('cart.flash_messages.success') } }
        format.json { render json: { status: :created, purchase: @purchase } }
      else
        format.html do
          flash[:danger] = t('cart.flash_messages.danger')
          render :edit
        end
        format.json { render json: { errors: @purchase.errors, status: :unprocessable_entity } }
      end
    end
  end

  private

  def set_purchase
    @purchase = authorize(Purchase.find(params[:id]))
  end

  def permit_params
    params.require(:purchase).permit(:country_code, :city,
                                     :address, :zip_code,
                                     :phone, :status)
  end
end
