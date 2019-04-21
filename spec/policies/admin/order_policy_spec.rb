require 'rails_helper'

RSpec.describe Admin::OrderPolicy, type: :policy do
  subject { described_class }

  permissions :index? do
    let(:items)         { create_list :item, 10, category: category }
    let(:purchase)      { create :purchase, user: purchase_user }
    let(:category)      { create :category }
    let(:purchase_user) { create :user }
    let(:orders) do
      items.map do |item|
        create :order, purchase: purchase, item: item, user: purchase_user
      end
    end

    context 'with orders' do
      include_examples 'admin or higher user(with access)' do
        let(:record) { orders }
      end
    end

    context 'without orders' do
      include_examples 'admin or higher user(without access)' do
        let(:record) { [] }
      end
    end

    include_examples 'standard user' do
      let(:record) { orders }
    end
  end
end
