module Admin
  class PurchasesController < AdminController
    before_action :set_purchase, only: %i[complete destroy]

    def index
      @purchases = Purchase.includes(:user, orders: :item).paginate(page: params[:page], per_page: Purchase::PER_PAGE)
    end

    def complete
      if @purchase.complete!
        flash[:success] = t('admin.purchase.flash_messages.complete.success')
      else
        flash[:danger] = t('admin.purchase.flash_messages.complete.danger')
      end
      redirect_to(admin_purchases_path)
    end

    def destroy
      if @purchase.destroy
        flash[:success] = t('admin.purchase.flash_messages.delete.success')
      else
        flash[:danger] = t('admin.purchase.flash_messages.delete.danger')
      end
      redirect_to(admin_purchases_path)
    end

    private

    def set_purchase
      @purchase = Purchase.find(params[:id] || params[:purchase_id])
    end
  end
end
