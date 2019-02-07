module Admin
  class PurchasesController < AdminController
    before_action :set_purchase, only: %i[complete destroy]

    def index
      @purchases = Purchase.with_orders
                           .with_status(params[:status])
                           .includes(:with_deleted_user, orders: [with_deleted_item: :versions])
                           .paginate(page: params[:page], per_page: Purchase::PER_PAGE)
      authorize([:admin, @purchases])
    end

    def complete
      if @purchase.completed!
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
      authorize([:admin, @purchase])
    end
  end
end
