require 'rails_helper'

RSpec.describe PurchasesController, type: :controller do
  describe 'GET edit' do
    include_examples 'assigns purchase in purchases controller' do
      let(:http_request) { get :edit, params: { id: purchase } }
    end
  end

  describe 'PATCH update' do
    let(:attributes) { attributes_for(:purchase) }

    describe 'purchase assigns' do
      include_examples 'assigns purchase in purchases controller' do
        let(:http_request) { patch :update, params: { id: purchase, purchase: attributes } }
      end
    end

    describe 'params processing' do
      login_user

      let!(:item)             { create :item, category: category }
      let(:category)          { create :category }
      let(:purchase)          { create :pending_purchase, user: current_user }
      let(:current_user)      { subject.current_user }
      let(:http_request)      { patch :update, params: { id: purchase, purchase: attributes } }
      let(:http_request_json) { patch :update, params: { id: purchase, purchase: attributes }, format: 'json' }

      before { create :order, item: item, user: current_user, purchase: purchase, quantity: 1 }

      context 'when data is valid' do
        it 'sets flash success' do
          expect(http_request.request.flash[:success]).to eq(I18n.t('cart.flash_messages.success'))
        end

        it 'redirect to' do
          http_request
          expect(response).to redirect_to(root_path)
        end

        include_examples 'sets status json', 'created'

        it 'check purchase id' do
          http_request_json
          expect(JSON.parse(response.body)['purchase']['id']).to eq(purchase.id)
        end
      end

      %w[country_code city address zip_code phone].each do |contact_field|
        context "when #{contact_field} is nil" do
          let(:attributes) do
            attr = attributes_for(:purchase)
            attr[contact_field.to_sym] = nil
            attr[:status] = 'processing'
            attr
          end

          it 'sets flash success' do
            expect(http_request.request.flash[:danger]).to eq(I18n.t('cart.flash_messages.danger'))
          end

          it { expect(http_request).to render_template(:edit) }

          include_examples 'sets status json', 'unprocessable_entity'
        end
      end
    end
  end
end
