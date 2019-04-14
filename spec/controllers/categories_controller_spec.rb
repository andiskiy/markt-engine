require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  describe 'GET show' do
    before { create_list :item, Item::PER_PAGE + 10, category: second_category }

    let(:http_request)          { get :show, params: { id: first_category } }
    let!(:items_first_category) { create_list :item, Item::PER_PAGE + 10, category: first_category }

    include_examples 'categories and purchase'

    it 'category assigns' do
      http_request
      expect(assigns(:category)).to eq(first_category)
    end

    it 'items assigns for first page' do
      http_request
      expect(assigns(:items)).to eq(items_first_category[0..Item::PER_PAGE - 1])
    end

    it 'items assigns for second page' do
      get :show, params: { id: first_category, page: 2 }
      expect(assigns(:items)).to eq(items_first_category[Item::PER_PAGE..Item::PER_PAGE + 9])
    end
  end
end
