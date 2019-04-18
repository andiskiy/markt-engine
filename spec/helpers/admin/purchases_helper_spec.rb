require 'rails_helper'

RSpec.describe Admin::PurchasesHelper, type: :helper do
  describe 'generate purchase status' do
    let(:user)                { create :user }
    let(:pending_purchase)    { create :pending_purchase, user: user }
    let(:completed_purchase)  { create :completed_purchase, user: user }
    let(:processing_purchase) { create :processing_purchase, user: user }

    let(:pending) do
      content_tag(:div, class: 'badge badge-warning') do
        concat(content_tag(:i, class: 'far fa-circle') {})
        concat(" #{I18n.t('admin.purchase.attributes.pending')}")
      end
    end
    let(:processing) do
      content_tag(:div, class: 'badge badge-primary') do
        concat(content_tag(:i, class: 'far fa-circle') {})
        concat(" #{I18n.t('admin.purchase.attributes.processing')}")
      end
    end
    let(:completed) do
      content_tag(:div, class: 'badge badge-success') do
        concat content_tag(:i, class: 'far fa-check-circle') {}
        concat(" #{I18n.t('admin.purchase.attributes.complete')}")
      end
    end

    it 'pending' do
      expect(helper.purchase_status(pending_purchase)).to eq(pending)
    end

    it 'processing' do
      expect(helper.purchase_status(processing_purchase)).to eq(processing)
    end

    it 'completed' do
      expect(helper.purchase_status(completed_purchase)).to eq(completed)
    end
  end

  describe 'customer name' do
    let(:user)             { create :user }
    let(:pending_purchase) { create :pending_purchase, user: user }
    let(:user_name) do
      content_tag(:a, href: admin_user_path(user), class: 'js-show-user') do
        user.full_name_with_email(pending_purchase.ordered_date)
      end
    end
    let(:user_deleted_name) do
      content_tag(:div, class: 'inline-block') { user.full_name_with_email(pending_purchase.ordered_date) }
    end

    it 'when not deleted' do
      expect(helper.customer(user, pending_purchase)).to eq(user_name)
    end

    it 'when deleted' do
      user.destroy
      expect(helper.customer(user, pending_purchase)).to eq(user_deleted_name)
    end
  end
end
