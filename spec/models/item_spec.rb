require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:user)              { create :user }
  let(:category)          { create :category }
  let(:purchase)          { create :pending_purchase, user: user }
  let(:old_name)          { 'New name' }
  let(:old_price)         { 100 }
  let(:item_photo)        { create :item_photo, item: item }
  let(:prev_category)     { create :category }
  let(:active_item_photo) { create :item_photo, item: item, active: true }
  let(:item) do
    create :item, category: category, name: old_name, price: old_price, prev_category: prev_category
  end

  describe 'versionable' do
    let(:new_name)  { 'New name' }
    let(:new_price) { 100 }

    before { item.update(name: new_name, price: new_price) }

    include_examples 'versionable', %w[name price] do
      let(:model) { item }
    end
  end

  describe 'associations' do
    let(:orders)             { [first_order, second_order] }
    let(:first_user)         { create :user }
    let(:second_user)        { create :user }
    let(:first_order)        { create :order, user: first_user, purchase: pending_purchase, item: item }
    let(:second_order)       { create :order, user: second_user, purchase: completed_purchase, item: item }
    let(:pending_purchase)   { create :pending_purchase, user: first_user }
    let(:completed_purchase) { create :completed_purchase, user: second_user }

    it 'category' do
      expect(item.category).to eq(category)
    end

    it 'prev_category' do
      expect(item.prev_category).to eq(prev_category)
    end

    it 'item_photos' do
      item_photo
      active_item_photo
      expect(item.item_photos).to eq([item_photo, active_item_photo])
    end

    it 'users' do
      orders
      expect(item.users.sort_by(&:id)).to eq([first_user, second_user])
    end

    it 'orders' do
      orders
      expect(item.orders).to eq(orders)
    end

    it 'pending_orders' do
      orders
      expect(item.pending_orders).to eq([first_order])
    end
  end

  describe 'validations' do
    it 'name presence' do
      expect(build(:item, name: nil)).not_to be_valid
    end

    it 'price presence' do
      expect(build(:item, price: nil)).not_to be_valid
    end

    it 'category must be exist' do
      expect(build(:item, category: nil)).not_to be_valid
    end
  end

  describe 'callbacks' do
    before do
      create :order, user: user, purchase: purchase, item: item
      create :order, user: user, purchase: purchase, item: item
    end

    it 'before delete item' do
      expect(purchase.orders.count).to eq(2)
    end

    it 'after delete item(delete_pending_orders)' do
      item.destroy
      expect(purchase.orders.count).to eq(0)
    end
  end

  describe 'scopes' do
    let(:first_name)      { '33444333' }
    let(:second_name)     { '11444111' }
    let!(:first_item)     { create :item, name: first_name, category: category }
    let!(:second_item)    { create :item, name: second_name, category: second_category }
    let(:second_category) { create :category }

    it 'order by name' do
      expect(described_class.order_by_name.to_a).to eq([second_item, first_item])
    end

    it 'search #1' do
      expect(described_class.search('444', '').to_a).to eq([second_item, first_item])
    end

    it 'search #2' do
      expect(described_class.search('444', category.id).to_a).to eq([first_item])
    end
  end

  describe 'methods' do
    let(:order) { create :order, purchase: purchase, user: user, item: item }
    let(:orders) do
      item_temp = create :item, category: category
      create :order, purchase: purchase, user: user, item: item_temp
      purchase_temp = create :processing_purchase, user: user
      create :order, purchase: purchase_temp, user: user, item: item
    end

    it 'active_photo' do
      item_photo
      active_item_photo
      expect(item.active_photo).to eq(active_item_photo)
    end

    it 'thumb_url' do
      item_photo
      active_item_photo
      expect(item.thumb_url).to match(%r{/uploads/item_photo/photo/#{active_item_photo.id}/thumb_test.jpg})
    end

    it 'ensure_five_photos' do
      item.ensure_five_photos
      expect(item.item_photos.length).to eq(5)
    end

    it 'order' do
      order
      orders
      expect(item.order(purchase, user)).to eq(order)
    end

    it '#needed_photos_count returns 5' do
      expect(item.send(:needed_photos_count)).to eq(5)
    end

    it '#needed_photos_count returns 3' do
      item_photo
      active_item_photo
      expect(item.send(:needed_photos_count)).to eq(3)
    end
  end

  context 'when association item photos' do
    it 'dependent destroy' do
      item_photo
      expect { item.destroy }.to change(ItemPhoto, :count).by(-1)
    end
  end
end
