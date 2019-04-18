require 'rails_helper'

RSpec.describe Admin::ItemsHelper, type: :helper do
  describe 'get link for category' do
    let(:name)     { 'Category name in helper' }
    let(:category) { create :category, name: name }

    it 'return link to category' do
      allow(view).to receive(:action_name).and_return('all_items')
      expect(helper.category_name(category)).to match(/#{link_to(name, admin_category_items_path(category))}/)
    end

    it 'return only category name' do
      allow(view).to receive(:action_name).and_return('index')
      expect(helper.category_name(category)).to eq(name)
    end
  end
end
