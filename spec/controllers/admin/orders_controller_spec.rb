require 'rails_helper'

RSpec.describe Admin::OrdersController, type: :controller do
  describe 'GET admin/index' do
    let!(:user)        { create :user }
    let!(:purchase)    { create :pending_purchase, user: user }
    let(:http_request) { get :index, params: { purchase_id: purchase } }

    context 'when user is admin' do
      login_admin

      let(:http_request_js) { get :index, params: { purchase_id: purchase }, xhr: true }

      context 'and valid data' do
        let!(:item)         { create :item, name: old_item_name, category: category }
        let!(:items)        { create_list :item, Order::PER_PAGE + 10, category: category }
        let(:category)      { create :category }
        let(:remove_item)   { item.destroy }
        let(:old_item_name) { 'Old item name' }
        let(:new_item_name) { 'New item name' }

        let(:purchase_processing) do
          purchase.processing!
          purchase.update(ordered_at: 5.seconds.ago)
        end
        let(:update_item_name) do
          item.update(name: new_item_name)
          item.versions.update(created_at: 1.second.ago)
        end
        let!(:orders) do
          (items << item).map do |map_item|
            create :order, item: map_item, purchase: purchase, user: user
          end
        end

        it 'purchase assigns' do
          http_request
          expect(assigns(:purchase)).to eq(purchase)
        end

        it 'get orders from first page' do
          http_request
          expect(assigns(:orders)).to eq(orders[0..(Item::PER_PAGE - 1)])
        end

        it 'get orders from second page with deleted item(pending purchase)' do
          remove_item
          get :index, params: { purchase_id: purchase, page: 2 }
          expect(assigns(:orders)).to eq(orders[Item::PER_PAGE..(Item::PER_PAGE + 9)])
        end

        it 'get orders from second page with deleted item(processing purchase)' do
          purchase_processing
          remove_item
          get :index, params: { purchase_id: purchase, page: 2 }
          expect(assigns(:orders)).to eq(orders[Item::PER_PAGE..(Item::PER_PAGE + 10)])
        end

        it 'get orders from second page with deleted item(before processing purchase)' do
          remove_item
          purchase_processing
          get :index, params: { purchase_id: purchase, page: 2 }
          expect(assigns(:orders)).to eq(orders[Item::PER_PAGE..(Item::PER_PAGE + 9)])
        end

        it 'get order by search old item name(pending purchase)' do
          update_item_name
          get :index, params: { purchase_id: purchase, value: old_item_name }
          expect(assigns(:orders).count).to eq(0)
        end

        it 'get order by search new item name(pending purchase)' do
          update_item_name
          get :index, params: { purchase_id: purchase, value: new_item_name }
          expect(assigns(:orders).pluck(:item_id)).to eq([item.id])
        end

        it 'get order by search new item name when remove item(pending purchase)' do
          update_item_name
          remove_item
          get :index, params: { purchase_id: purchase, value: new_item_name }
          expect(assigns(:orders).count).to eq(0)
        end

        %w[old new].each do |name|
          it "get order by search #{name} item name(processing purchase)" do
            purchase_processing
            update_item_name
            get :index, params: { purchase_id: purchase, value: send("#{name}_item_name") }
            expect(assigns(:orders).pluck(:item_id)).to eq([item.id])
          end
        end

        include_examples 'render partial js', 'admin/orders/_orders_list'
      end

      context 'and invalid data' do
        it 'access denied for purchase without orders' do
          expect(http_request).to render_template('users/sessions/access_denied')
        end
      end
    end

    include_examples 'no access to admin panel'
  end
end
