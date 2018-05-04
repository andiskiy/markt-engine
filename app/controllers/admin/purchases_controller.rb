module Admin
  class PurchasesController < AdminController

    def index
      @purchases = Purchase.all
    end

    def show
      @orders = Purchase.find(params[:id]).orders
    end

  end
end