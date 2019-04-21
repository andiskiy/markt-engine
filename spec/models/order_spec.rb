require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:user)     { create :user }
  let(:item)     { create :item, name: old_name, category: category }
  let(:order)    { create :order, item: item, user: user, purchase: purchase }
  let(:old_name) { 'Old name' }
  let(:category) { create :category }
  let(:purchase) { create :purchase, user: user }
  let(:update_order) do
    order.update(quantity: 2)
  end

  describe 'associations' do
    it 'item' do
      expect(order.item).to eq(item)
    end

    it 'purchase' do
      expect(order.purchase).to eq(purchase)
    end

    it 'user' do
      expect(order.user).to eq(user)
    end

    it 'with_deleted_item' do
      item.destroy
      expect(order.with_deleted_item).to eq(item)
    end
  end

  describe 'callbacks' do
    it 'delete order' do
      order.decrease!
      expect { order.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'does not delete order' do
      update_order
      order.decrease!
      expect(order.destroyed?).to eq(false)
    end
  end

  describe 'scopes' do
    let(:new_name) { 'New name' }

    let!(:new_order) do
      order
      item_temp = create :item, category: category
      create :order, item: item_temp, user: user, purchase: purchase
    end

    context 'when purchase is pending' do
      before { purchase.update(ordered_at: 10.seconds.from_now) }

      include_examples 'search_with_deleted' do
        let(:update_item)           { item.update(name: new_name) }
        let(:old_name_item_changed) { [] }
        let(:new_name_item_changed) { [order] }
      end
    end

    %w[processing completed].each do |purchase_status|
      context "when purchase is #{purchase_status}" do
        let(:purchase) { create "#{purchase_status}_purchase", user: user, ordered_at: 10.seconds.ago }

        include_examples 'search_with_deleted' do
          let(:old_name_item_changed) { [order] }
          let(:new_name_item_changed) { [order] }
          let(:update_item) do
            item.update(name: new_name)
            item.destroy
          end
        end
      end
    end

    it 'order_by_id' do
      expect(described_class.order_by_id).to eq_id_list_of([order, new_order])
    end
  end

  describe 'methods' do
    it 'increase!' do
      order.increase!
      expect(order.quantity).to eq(2)
    end

    it 'decrease!' do
      update_order
      order.decrease!
      expect(order.quantity).to eq(1)
    end
  end
end
