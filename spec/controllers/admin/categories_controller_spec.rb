require 'rails_helper'

RSpec.describe Admin::CategoriesController, type: :controller do
  describe 'GET admin/index' do
    let!(:categories)  { (create_list :category, Category::PER_PAGE + 10).sort_by(&:name) }
    let(:http_request) { get :index }

    context 'when user is admin' do
      login_admin
      let(:name)            { 'Category for search' }
      let(:category)        { create :category, name: name }
      let(:http_request_js) { get :index, xhr: true }

      it 'get categories from first page' do
        http_request
        expect(assigns(:categories)).to eq_id_list_of(categories[0..(Category::PER_PAGE - 1)])
      end

      it 'get categories from second page' do
        get :index, params: { page: 2 }
        expect(assigns(:categories)).to eq_id_list_of(categories[Category::PER_PAGE..(Category::PER_PAGE + 9)])
      end

      it 'get categories by search' do
        category
        get :index, params: { value: name }
        expect(assigns(:categories)).to eq_id_list_of([category])
      end

      include_examples 'render partial js', 'admin/categories/_categories'
    end

    include_examples 'no access to admin panel'
  end

  describe 'GET admin/show' do
    let!(:category)    { create :category }
    let(:http_request) { get :show, params: { id: category } }

    context 'when user is admin' do
      login_admin

      it 'category assigns' do
        http_request
        expect(assigns(:category)).to eq(category)
      end
    end

    include_examples 'no access to admin panel'
  end

  describe 'GET admin/new' do
    let(:http_request) { get :new }

    context 'when user is admin' do
      login_admin

      it 'category assigns' do
        http_request
        expect(assigns(:category)).to be_a_new(Category)
      end
    end

    include_examples 'no access to admin panel'
  end

  describe 'GET admin/edit' do
    let!(:category)    { create :category }
    let(:http_request) { get :edit, params: { id: category } }

    context 'when user is admin' do
      login_admin

      it 'category assigns' do
        http_request
        expect(assigns(:category)).to eq(category)
      end
    end

    include_examples 'no access to admin panel'
  end

  describe 'POST admin/create' do
    let(:attributes)    { { name: category_name, description: 'This is description' } }
    let(:http_request)  { post :create, params: { category: attributes } }
    let(:category_name) { 'New Category' }

    context 'when user is admin' do
      login_admin

      let(:http_request_json) { post :create, params: { category: attributes }, format: 'json' }

      context 'and valid data' do
        it { expect(http_request).to redirect_to(admin_categories_path) }

        it { expect { http_request }.to change(Category, :count).by(1) }

        it 'category created' do
          http_request
          expect(assigns(:category).name).to eq(category_name)
        end

        it 'sets flash success' do
          expect(http_request.request.flash[:success]).to eq(I18n.t('admin.category.flash_messages.create.success'))
        end

        include_examples 'sets status json', 'created'

        it 'check created category name when format json' do
          http_request_json
          expect(JSON.parse(response.body)['category']['name']).to eq(category_name)
        end
      end

      context 'and invalid data' do
        let(:attributes) { { name: nil, description: 'This is description' } }

        it { expect(http_request).to render_template(:new) }

        it { expect { http_request }.to change(Category, :count).by(0) }

        it 'sets flash danger' do
          expect(http_request.request.flash[:danger]).to eq(I18n.t('admin.category.flash_messages.create.danger'))
        end

        include_examples 'sets status json', 'unprocessable_entity'
      end
    end

    include_examples 'no access to admin panel'
  end

  describe 'PATCH admin/update' do
    let(:new_name)     { 'Updated category name' }
    let!(:category)    { create :category }
    let(:attributes)   { { name: new_name, description: 'This is description' } }
    let(:http_request) { patch :update, params: { id: category, category: attributes } }

    context 'when user is admin' do
      login_admin

      let(:http_request_json) do
        patch :update, params: { id: category, category: attributes }, format: 'json'
      end

      context 'and valid data' do
        it { expect(http_request).to redirect_to(admin_categories_path) }

        it 'name changed' do
          http_request
          expect(assigns(:category).name).to eq(new_name)
        end

        it 'sets flash success' do
          expect(http_request.request.flash[:success]).to eq(I18n.t('admin.category.flash_messages.update.success'))
        end

        include_examples 'sets status json', 'updated'

        it 'check updated category name when format json' do
          http_request_json
          expect(JSON.parse(response.body)['category']['name']).to eq(new_name)
        end
      end

      context 'and invalid data' do
        let(:attributes) { { name: nil, description: 'This is description' } }

        it { expect(http_request).to render_template(:edit) }

        it 'sets flash danger' do
          expect(http_request.request.flash[:danger]).to eq(I18n.t('admin.category.flash_messages.update.danger'))
        end

        include_examples 'sets status json', 'unprocessable_entity'
      end
    end

    include_examples 'no access to admin panel'
  end

  describe 'DELETE admin/destroy' do
    let!(:category)    { create :category }
    let(:http_request) { delete :destroy, params: { id: category } }

    context 'when user is admin' do
      login_admin

      let(:http_request_json) { delete :destroy, params: { id: category }, format: 'json' }

      it { expect(http_request).to redirect_to(admin_categories_path) }

      context 'and valid data' do
        it { expect { http_request }.to change(Category, :count).by(-1) }

        it 'sets flash success' do
          expect(http_request.request.flash[:success]).to eq(I18n.t('admin.category.flash_messages.delete.success'))
        end

        include_examples 'sets status json', 'deleted'
      end

      context 'and invalid data(has items)' do
        before { create_list :item, 5, category: category }

        it { expect { http_request }.to change(Category, :count).by(0) }

        it 'access denied' do
          expect(http_request).to render_template('users/sessions/access_denied')
        end
      end
    end

    include_examples 'no access to admin panel'
  end

  describe 'GET admin/move_items' do
    let!(:category) { create :category }
    let(:http_request) { get :move_items, params: { category_id: category } }

    context 'when user is admin' do
      login_admin

      let!(:categories) { (create_list :category, 5) }

      it 'category assigns' do
        http_request
        expect(assigns(:category)).to eq(category)
      end

      it 'categories assigns' do
        http_request
        expect(assigns(:categories)).to eq_id_list_of(categories)
      end
    end

    include_examples 'no access to admin panel'
  end

  describe 'PATCH admin/update_items' do
    let!(:old_category) { create :category }
    let!(:new_category) { create :category }
    let(:http_request) do
      get :update_items, params: { category_id: old_category, category: { category_id: new_category } }
    end

    context 'when user is admin' do
      login_admin

      let!(:items) { create_list :item, 5, category: old_category }
      let(:http_request_json) do
        get :update_items,
            params: { category: { category_id: new_category }, category_id: old_category },
            format: 'json'
      end

      let(:flash_message) do
        I18n.t('admin.category.flash_messages.update_items.success', category: old_category.name)
      end

      it 'category assigns' do
        http_request
        expect(assigns(:category)).to eq(old_category)
      end

      it 'items assigns' do
        items
        http_request
        expect(new_category.items).to eq_id_list_of(items)
      end

      it 'sets flash success' do
        expect(http_request.request.flash[:success]).to eq(flash_message)
      end

      include_examples 'sets status json', 'updated'
    end

    include_examples 'no access to admin panel'
  end
end
