require 'rails_helper'

RSpec.describe Admin::PurchasesController, type: :controller do
  before do
    create :pending_purchase, user: user
    items.each do |item|
      create :order, item: item, purchase: purchase_pending, user: user
      create :order, item: item, purchase: purchase_completed, user: user
      create :order, item: item, purchase: purchase_processing, user: user
    end
    purchase_pending_with_deleted_item = create :pending_purchase, user: user
    deleted_item = create :item, category: category
    user2 = create :user
    create :order, item: deleted_item, purchase: purchase_pending_with_deleted_item, user: user2
    create :order, item: deleted_item, purchase: purchase_completed_with_deleted_item, user: user2
    deleted_item.destroy
  end

  let!(:user)               { create :user }
  let!(:items)              { create_list :item, Order::PER_PAGE + 10, category: category }
  let!(:category)           { create :category }
  let(:purchase_pending)    { create :pending_purchase, user: user }
  let(:purchase_processing) { create :processing_purchase, user: user }
  let(:purchase_completed)  { create :completed_purchase, user: user }
  let(:purchase_completed_with_deleted_item) { create :completed_purchase, user: user }

  describe 'GET admin/index' do
    let(:http_request) { get :index }

    context 'when user is admin' do
      login_admin
      let!(:purchases) do
        [purchase_pending, purchase_completed, purchase_processing,
         purchase_completed_with_deleted_item]
      end
      let(:purchase_only_completed) do
        [purchase_completed, purchase_completed_with_deleted_item]
      end

      it 'purchases assigns' do
        http_request
        expect(assigns(:purchases)).to eq_id_list_of(purchases)
      end

      %w[pending processing only_completed].each do |status|
        it "#{status.sub('_', ' ')} purchases" do
          get :index, params: { status: status.sub('only_', '') }
          expect(assigns(:purchases)).to eq_id_list_of([*send("purchase_#{status}")])
        end
      end
    end

    include_examples 'no access to admin panel'
  end

  describe 'POST admin/complete' do
    let(:http_request) { post :complete, params: { purchase_id: purchase_processing } }

    context 'when user is admin' do
      login_admin

      context 'and valid data' do
        it { expect(http_request).to redirect_to(admin_purchases_path) }

        it 'purchase completed' do
          http_request
          expect(assigns(:purchase).completed?).to be(true)
        end

        it 'sets flash success' do
          expect(http_request.request.flash[:success]).to eq(I18n.t('admin.purchase.flash_messages.complete.success'))
        end
      end

      context 'and invalid data' do
        %w[purchase_pending purchase_completed].each do |purchase|
          let(:http_request) { post :complete, params: { purchase_id: send(purchase) } }

          it "#{purchase.sub('_', ' ')} access denied" do
            expect(http_request).to render_template('users/sessions/access_denied')
          end
        end
      end
    end

    include_examples 'no access to admin panel'
  end

  describe 'DELETE admin/destroy' do
    let(:http_request) { post :destroy, params: { id: purchase_completed } }

    context 'when user is admin' do
      login_admin

      %w[purchase_pending purchase_processing purchase_completed].each do |purchase|
        context purchase do
          let(:http_request) { post :destroy, params: { id: send(purchase) } }

          it { expect(http_request).to redirect_to(admin_purchases_path) }

          it { expect { http_request }.to change(Purchase, :count).by(-1) }

          it 'sets flash success' do
            expect(http_request.request.flash[:success]).to eq(I18n.t('admin.purchase.flash_messages.delete.success'))
          end
        end
      end
    end

    include_examples 'no access to admin panel'
  end
end
