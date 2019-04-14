require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  describe 'POST create' do
    let!(:item)        { create :item, category: category, price: price }
    let(:price)        { 50 }
    let(:category)     { create :category }
    let(:http_request) { post :create, params: { item_id: item.id } }

    context 'when user is authorized' do
      login_user

      let(:order)             { create :order, purchase: purchase, user: current_user, item: item, quantity: 1 }
      let!(:purchase)         { create :pending_purchase, user: current_user }
      let(:current_user)      { subject.current_user }
      let(:http_request_json) { post :create, params: { item_id: item.id }, format: 'json' }

      it { expect { http_request }.to change(Order, :count).by(1) }

      it 'order exists(should be increase quantity)' do
        order
        expect { http_request }.to change(Order, :count).by(0)
      end

      it 'order quantity should be one' do
        http_request
        expect(Order.find_by(user: current_user, purchase: purchase, item: item).quantity).to eq(1)
      end

      it 'order quantity should be two' do
        order
        http_request
        expect(Order.find_by(user: current_user, purchase: purchase, item: item).quantity).to eq(2)
      end

      it 'sets flash success' do
        expect(http_request.request.flash[:success]).to eq(I18n.t('cart.flash_messages.create.success'))
      end

      it 'amount' do
        http_request_json
        expect(JSON.parse(response.body)['purchase']['amount']).to eq(price)
      end

      include_examples 'sets status json', 'created'

      it 'check item_id from order' do
        http_request_json
        expect(JSON.parse(response.body)['order']['item_id']).to eq(item.id)
      end
    end

    context 'when user is not authorized' do
      it 'redirect to' do
        http_request
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    include_examples 'set purchase'
  end

  describe 'DELETE destroy' do
    let(:http_request)    { delete :destroy, params: { id: order_purchase.id } }
    let!(:order_purchase) { create :order, quantity: 1 }

    context 'when user is authorized' do
      login_user

      let!(:item)             { create :item, category: category, price: price }
      let(:price)             { 50 }
      let!(:order)            { create :order, purchase: purchase, user: current_user, item: item, quantity: 1 }
      let(:category)          { create :category }
      let!(:purchase)         { create :pending_purchase, user: current_user }
      let(:http_request)      { delete :destroy, params: { id: order.id } }
      let(:http_request_json) { delete :destroy, params: { id: order.id }, format: 'json' }

      let(:current_user) { subject.current_user }

      it { expect { http_request }.to change(Order, :count).by(-1) }

      it do
        order.increase!
        expect { http_request_json }.to change(Order, :count).by(0)
      end

      it 'order should be deleted' do
        order.increase!
        http_request
        expect(Order.find_by(user: current_user, purchase: purchase, item: item)).to be_nil
      end

      it 'order quantity should be decreased' do
        order.increase!
        http_request_json
        expect(Order.find_by(user: current_user, purchase: purchase, item: item).quantity).to eq(1)
      end

      it 'sets flash success' do
        expect(http_request.request.flash[:success]).to eq(I18n.t('cart.flash_messages.delete.success'))
      end

      it 'amount' do
        order.increase!
        order.increase!
        http_request_json
        expect(JSON.parse(response.body)['purchase']['amount']).to eq(price * 2)
      end

      include_examples 'sets status json', 'deleted'

      it 'check item_id from order' do
        http_request_json
        expect(JSON.parse(response.body)['order']['item_id']).to eq(item.id)
      end
    end

    context 'when user is not authorized' do
      it 'redirect to' do
        http_request
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    include_examples 'set purchase'
  end
end
