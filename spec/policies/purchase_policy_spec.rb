require 'rails_helper'

RSpec.describe PurchasePolicy, type: :policy do
  subject { described_class }

  permissions :edit?, :update? do
    let(:user) { create :user }

    context 'when purchase is pending' do
      let(:purchase) { create :pending_purchase, user: user }

      context 'and has orders' do
        let(:items) { create_list :item, 10 }

        before do
          items.map do |item|
            create :order, purchase: purchase, user: user, item: item
          end
        end

        context 'and user matches' do
          it { is_expected.to permit(user, purchase) }
        end

        context 'and user does not match' do
          let(:new_user) { create :user }

          it { is_expected.not_to permit(new_user, purchase) }
        end
      end

      context 'and has not orders' do
        it { is_expected.not_to permit(user, purchase) }
      end
    end

    %w[processing_purchase completed_purchase].each do |purchase_status|
      context "when #{purchase_status}" do
        let(:items)    { create_list :item, 10 }
        let(:purchase) { create purchase_status }

        before do
          items.map do |item|
            create :order, purchase: purchase, user: user, item: item
          end
        end

        it { is_expected.not_to permit(user, purchase) }
      end
    end
  end
end
