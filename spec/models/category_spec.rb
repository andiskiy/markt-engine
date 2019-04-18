require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'associations' do
    let(:first_items)     { create_list(:item, 100, category: first_category).sort_by(&:name) }
    let(:second_items)    { create_list(:item, 100, category: second_category).sort_by(&:name) }
    let(:first_category)  { create :category }
    let(:second_category) { create :category }

    it 'items for first_category' do
      expect(first_category.items).to eq(first_items)
    end

    it 'items for second_category' do
      expect(second_category.items).to eq(second_items)
    end
  end

  describe 'validations' do
    it 'name presence' do
      expect(build(:category, name: nil)).not_to be_valid
    end
  end

  describe 'scopes' do
    let(:name)       { 'AAAAAAAA' }
    let(:category)   { create :category, name: name }
    let(:categories) { create_list(:category, 100).sort_by(&:name) }

    it 'search' do
      categories
      category
      expect(described_class.search(name)).to eq([category])
    end

    it 'order by' do
      categories
      category
      expect(described_class.all.order_by_name.first).to eq(category)
    end
  end
end
