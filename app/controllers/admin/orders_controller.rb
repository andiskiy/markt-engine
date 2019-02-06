module Admin
  class OrdersController < AdminController
    before_action :set_purchase

    def index
      @orders = @purchase.orders
                         .includes(:item)
                         .search(params[:value])
                         .paginate(page: params[:page], per_page: Order::PER_PAGE)
      authorize([:admin, @orders])
      respond_to do |format|
        format.html {}
        format.js do
          render partial: 'admin/orders/orders_list', layout: false, locals: { orders: @orders }
        end
      end
    end

    private

    def set_purchase
      @purchase = Purchase.find(params[:purchase_id])
    end
  end
end
