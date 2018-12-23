module Admin
  class PurchasesController < AdminController

    before_action :set_purchase, only: [:show, :complete]

    def index
      @purchases = Purchase.all
    end

    def show
      @orders = @purchase.orders
    end

    def complete
      @purchase.update(status: 'completed')
      redirect_to admin_purchases_path
    end

    private

    def set_purchase
      @purchase = Purchase.find(params[:id] || params[:purchase_id])
    end
  end
end
