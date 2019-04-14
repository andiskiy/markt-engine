require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  describe 'GET show' do
    before { create_list :item, Item::PER_PAGE + 10, category: another_category }

    let(:http_request)            { get :show, params: { id: request_category } }
    let(:another_category)        { create :category }
    let(:request_category)        { create :category }
    let!(:items_request_category) { create_list :item, Item::PER_PAGE + 10, category: request_category }
    let!(:categories) do
      categories_temp = create_list :category, 10
      (categories_temp << another_category << request_category).sort_by(&:name)
    end

    context 'when user is authorized' do
      login_user

      let(:current_user)     { subject.current_user }
      let(:pending_purchase) { create :pending_purchase, user: current_user }

      it 'purchase assigns' do
        pending_purchase
        http_request
        expect(assigns(:purchase)).to eq(pending_purchase)
      end

      it 'exists purchase' do
        pending_purchase
        expect { http_request }.to change(Purchase, :count).by(0)
      end

      it 'created purchase' do
        expect { http_request }.to change(Purchase, :count).by(1)
      end
    end

    context 'when user is not authorized' do
      it 'purchase assigns' do
        http_request
        expect(assigns(:purchase)).to be_nil
      end

      it 'was not created purchase' do
        expect { http_request }.to change(Purchase, :count).by(0)
      end
    end

    it 'categories assigns' do
      http_request
      expect(assigns(:categories)).to eq(categories)
    end

    it 'category assigns' do
      http_request
      expect(assigns(:category)).to eq(request_category)
    end

    it 'items assigns for first page' do
      http_request
      expect(assigns(:items)).to eq(items_request_category[0..Item::PER_PAGE - 1])
    end

    it 'items assigns for second page' do
      get :show, params: { id: request_category, page: 2 }
      expect(assigns(:items)).to eq(items_request_category[Item::PER_PAGE..Item::PER_PAGE + 9])
    end
  end
end
