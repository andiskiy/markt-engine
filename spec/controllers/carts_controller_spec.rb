require 'rails_helper'

RSpec.describe CartsController, type: :controller do
  describe 'GET index' do
    let(:http_request) { get :index }

    context 'when user authorized' do
      login_user

      let(:user)                 { create :user }
      let(:items)                { create_list :item, 10, category: category }
      let(:category)             { create :category }
      let(:deleted_item)         { create :item, category: category }
      let!(:current_user)        { subject.current_user }
      let(:purchase_user)        { create :pending_purchase, user: user }
      let(:pending_purchase)     { create :pending_purchase, user: current_user }
      let!(:completed_purchase)  { create :completed_purchase, user: current_user }
      let!(:processing_purchase) { create :processing_purchase, user: current_user }
      let(:orders) do
        create :order, item: deleted_item, user: current_user, purchase: pending_purchase, quantity: 1
        deleted_item.destroy
        items.map do |item|
          create :order, item: item, user: current_user, purchase: pending_purchase, quantity: 1
        end
      end
      let(:another_orders) do
        item = create :item, category: category
        create :order, item: item, user: current_user, purchase: completed_purchase, quantity: 1
        create :order, item: item, user: current_user, purchase: processing_purchase, quantity: 1
        create :order, item: item, user: user, purchase: purchase_user, quantity: 1
        create :order, item: item, user: user, purchase: purchase_user, quantity: 1
        create :order, item: items[0], user: current_user, purchase: processing_purchase, quantity: 1
        create :order, item: items[1], user: current_user, purchase: completed_purchase, quantity: 1
      end

      it 'purchase assigns' do
        pending_purchase
        http_request
        expect(assigns(:purchase)).to eq(pending_purchase)
      end

      it 'purchase created' do
        expect { http_request }.to change(Purchase, :count).by(1)
      end

      it 'purchase exists' do
        pending_purchase
        expect { http_request }.to change(Purchase, :count).by(0)
      end

      it 'orders assigns' do
        pending_purchase
        another_orders
        orders
        http_request
        expect(assigns(:orders)).to eq(orders)
      end
    end

    context 'when user is not authorized' do
      it 'redirect to' do
        http_request
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
