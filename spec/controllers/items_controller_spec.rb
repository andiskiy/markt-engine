require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  describe 'GET index' do
    let(:http_request)          { get :index }
    let(:http_request_js)       { get :index, xhr: true }
    let(:search_item_name)      { 'Search item name' }
    let(:item_second_category)  { create :item, name: search_item_name, category: second_category }
    let(:items_first_category)  { create_list(:item, Item::PER_PAGE + 10, category: first_category).sort_by(&:name) }
    let(:items_second_category) { create_list :item, Item::PER_PAGE + 10, category: second_category }
    let!(:items) do
      ((items_first_category + items_second_category) << item_second_category).sort_by(&:name)
    end

    include_examples 'set categories'
    include_examples 'set purchase'

    include_examples 'render partial js', 'partials/_items'

    context 'without category' do
      it 'items assigns from first page' do
        http_request
        expect(assigns(:items)).to eq(items[0..Item::PER_PAGE - 1])
      end

      it 'items assigns from second page' do
        get :index, params: { page: 2 }
        expect(assigns(:items)).to eq(items[Item::PER_PAGE..(Item::PER_PAGE * 2 - 1)])
      end

      it 'items assigns by search name' do
        get :index, params: { value: search_item_name }
        expect(assigns(:items)).to eq([item_second_category])
      end

      it 'items assigns by search bad name' do
        get :index, params: { value: 'bad name' }
        expect(assigns(:items)).to eq([])
      end
    end

    context 'with category' do
      it 'items assigns from first page' do
        get :index, params: { category_id: first_category }
        expect(assigns(:items)).to eq(items_first_category[0..Item::PER_PAGE - 1])
      end

      it 'items assigns from second page' do
        get :index, params: { page: 2, category_id: first_category }
        expect(assigns(:items)).to eq(items_first_category[Item::PER_PAGE..(Item::PER_PAGE + 11)])
      end

      it 'items assigns by search name in second category' do
        get :index, params: { category_id: second_category, value: search_item_name }
        expect(assigns(:items)).to eq([item_second_category])
      end

      it 'items assigns by search name in first category' do
        get :index, params: { category_id: first_category, value: search_item_name }
        expect(assigns(:items)).to eq([])
      end

      it 'items assigns by search bad name' do
        get :index, params: { category_id: first_category, value: 'bad name' }
        expect(assigns(:items)).to eq([])
      end
    end
  end

  describe 'GET show' do
    let!(:item)        { create :item, category: category }
    let(:category)     { create :category }
    let(:http_request) { get :show, params: { id: item } }

    it 'purchase assigns' do
      http_request
      expect(assigns(:item)).to eq(item)
    end
  end
end
