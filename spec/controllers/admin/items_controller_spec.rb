require 'rails_helper'

RSpec.describe Admin::ItemsController, type: :controller do
  let(:category) { create :category }

  describe 'GET admin/all_items' do
    let(:http_request) { get :all_items }
    let!(:items) do
      category1 = create :category
      category2 = create :category
      items_list1 = create_list :item, Item::PER_PAGE, category: category1
      items_list2 = create_list :item, Item::PER_PAGE, category: category2
      (items_list1 + items_list2).sort_by(&:name)
    end

    context 'when user is admin' do
      login_admin

      let(:name)            { 'Item for search' }
      let(:item)            { create :item, name: name }
      let(:http_request_js) { get :all_items, xhr: true }

      it 'get items from first page' do
        http_request
        expect(assigns(:items)).to eq(items[0..(Item::PER_PAGE - 1)])
      end

      it 'get items from second page' do
        get :all_items, params: { page: 2 }
        expect(assigns(:items)).to eq(items[Item::PER_PAGE..(Item::PER_PAGE * 2 - 1)])
      end

      it 'get items by search' do
        item
        get :all_items, params: { value: name }
        expect(assigns(:items)).to eq([item])
      end

      include_examples 'render partial js', 'admin/items/_items_table'
    end

    include_examples 'no access to admin panel'
  end

  describe 'GET admin/index' do
    before { create_list :item, Item::PER_PAGE + 10, category: secondary_category }

    let!(:main_items)        { create_list(:item, Item::PER_PAGE + 10, category: main_category).sort_by(&:name) }
    let(:http_request)       { get :index, params: { category_id: main_category } }
    let(:main_category)      { create :category }
    let(:secondary_category) { create :category }

    context 'when user is admin' do
      login_admin

      let(:name)            { 'Item for search' }
      let(:item)            { create :item, name: name, category: main_category }
      let(:http_request_js) { get :index, params: { category_id: main_category }, xhr: true }

      it 'category assigns' do
        http_request
        expect(assigns(:category)).to eq(main_category)
      end

      it 'get items from first page' do
        http_request
        expect(assigns(:items)).to eq(main_items[0..(Item::PER_PAGE - 1)])
      end

      it 'get items from second page' do
        get :index, params: { category_id: main_category, page: 2 }
        expect(assigns(:items)).to eq(main_items[Item::PER_PAGE..(Item::PER_PAGE + 9)])
      end

      include_examples 'render partial js', 'admin/categories/_items'
    end

    include_examples 'no access to admin panel'
  end

  describe 'GET admin/show' do
    let!(:item)        { create :item, category: category }
    let(:http_request) { get :show, params: { category_id: category, id: item } }

    context 'when user is admin' do
      login_admin

      it 'item assigns' do
        http_request
        expect(assigns(:item)).to eq(item)
      end
    end

    include_examples 'no access to admin panel'
  end

  describe 'GET admin/new' do
    let(:http_request) { get :new, params: { category_id: category } }

    context 'when user is admin' do
      login_admin

      it 'item assigns' do
        http_request
        expect(assigns(:item)).to be_a_new(Item)
      end
    end

    include_examples 'no access to admin panel'
  end

  describe 'GET admin/edit' do
    let!(:item)        { create :item, category: category }
    let(:http_request) { get :edit, params: { category_id: category, id: item } }

    context 'when user is admin' do
      login_admin

      it 'item assigns' do
        http_request
        expect(assigns(:item)).to eq(item)
      end
    end

    include_examples 'no access to admin panel'
  end

  describe 'POST admin/create' do
    let(:item_name)    { 'New item' }
    let(:http_request) { post :create, params: { category_id: category, item: attributes } }
    let(:attributes) do
      attr = attributes_for(:item)
      attr[:name] = item_name
      attr
    end

    context 'when user is admin' do
      login_admin

      let(:http_request_json) { post :create, params: { category_id: category, item: attributes }, format: 'json' }

      context 'and valid data' do
        it { expect(http_request).to redirect_to(admin_category_items_path(category)) }

        it { expect { http_request }.to change(Item, :count).by(1) }

        it 'item created' do
          http_request
          expect(assigns(:item).name).to eq(item_name)
        end

        it 'sets flash success' do
          expect(http_request.request.flash[:success]).to eq(I18n.t('admin.item.flash_messages.create.success'))
        end

        include_examples 'sets status json', 'created'

        it 'check created item name when format json' do
          http_request_json
          expect(JSON.parse(response.body)['item']['name']).to eq(item_name)
        end
      end

      %w[name price category_id].each do |field|
        context "and invalid data(#{field} is nil)" do
          let(:attributes) { { "#{field}": nil, description: 'This is description' } }

          it { expect(http_request).to render_template(:new) }

          it { expect { http_request }.to change(Item, :count).by(0) }

          it 'sets flash danger' do
            expect(http_request.request.flash[:danger]).to eq(I18n.t('admin.item.flash_messages.create.danger'))
          end

          include_examples 'sets status json', 'unprocessable_entity'
        end
      end
    end

    include_examples 'no access to admin panel'
  end

  describe 'PATCH admin/update' do
    let!(:item)        { create :item, category: category }
    let(:new_name)     { 'Updated item name' }
    let(:attributes)   { { name: new_name } }
    let(:http_request) { patch :update, params: { category_id: category, id: item, item: attributes } }

    context 'when user is admin' do
      login_admin

      let(:http_request_json) do
        patch :update, params: { category_id: category, id: item, item: attributes }, format: 'json'
      end

      context 'and valid data' do
        it { expect(http_request).to redirect_to(admin_category_items_path(category)) }

        it 'name changed' do
          http_request
          expect(assigns(:item).name).to eq(new_name)
        end

        it 'sets flash success' do
          expect(http_request.request.flash[:success]).to eq(I18n.t('admin.item.flash_messages.update.success'))
        end

        include_examples 'sets status json', 'updated'

        it 'check updated item name when format json' do
          http_request_json
          expect(JSON.parse(response.body)['item']['name']).to eq(new_name)
        end
      end

      %w[name price category_id].each do |field|
        context 'and invalid data' do
          let(:attributes) { { "#{field}": nil, description: 'This is description' } }

          it { expect(http_request).to render_template(:edit) }

          it 'sets flash danger' do
            expect(http_request.request.flash[:danger]).to eq(I18n.t('admin.item.flash_messages.update.danger'))
          end

          include_examples 'sets status json', 'unprocessable_entity'
        end
      end
    end

    include_examples 'no access to admin panel'
  end

  describe 'DELETE admin/destroy' do
    let!(:item)        { create :item, category: category }
    let(:http_request) { delete :destroy, params: { category_id: category, id: item } }

    context 'when user is admin' do
      login_admin

      let(:http_request_json) { delete :destroy, params: { category_id: category, id: item }, format: 'json' }

      it { expect(http_request).to redirect_to(admin_category_items_path(category)) }

      it { expect { http_request }.to change(Item, :count).by(-1) }

      it 'sets flash success' do
        expect(http_request.request.flash[:success]).to eq(I18n.t('admin.item.flash_messages.delete.success'))
      end

      include_examples 'sets status json', 'deleted'
    end

    include_examples 'no access to admin panel'
  end
end
