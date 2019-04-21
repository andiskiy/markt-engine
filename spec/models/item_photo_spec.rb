require 'rails_helper'

RSpec.describe ItemPhoto, type: :model do
  describe 'associations' do
    let(:item)       { create :item, category: category }
    let(:category)   { create :category }
    let(:item_photo) { create :item_photo, item: item }

    it 'item' do
      expect(item_photo.item).to eq(item)
    end
  end

  describe 'validations' do
    it 'photo presence' do
      expect(build(:item_photo, photo: nil)).not_to be_valid
    end

    it 'item must be exist' do
      expect(build(:item_photo, item: nil)).not_to be_valid
    end
  end
end
