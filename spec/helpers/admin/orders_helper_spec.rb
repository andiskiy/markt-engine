require 'rails_helper'

RSpec.describe Admin::OrdersHelper, type: :helper do
  describe 'get new or old item name' do
    let(:user)     { create :user }
    let(:name)     { 'Item name' }
    let(:item)     { create :item, name: name, category: category }
    let(:category) { create :category }
    let(:purchase) { create :pending_purchase, user: user }
    let(:item_link) do
      content_tag(:a, href: admin_category_item_path(item.category, item)) do
        concat(content_tag(:i, class: 'fas fa-gift') {})
        concat(" #{name}")
      end
    end
    let(:deleted_item_link) do
      content_tag(:div) do
        concat(content_tag(:i, class: 'fas fa-gift') {})
        concat(" #{name}")
      end
    end

    before { create :order, user: user, item: item, purchase: purchase }

    it 'link to deleted item' do
      item.destroy
      expect(helper.order_item(item, purchase)).to eq(deleted_item_link)
    end

    it 'link to not deleted item' do
      expect(helper.order_item(item, purchase)).to eq(item_link)
    end
  end
end
