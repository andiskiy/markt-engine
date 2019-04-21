require 'rails_helper'

RSpec.describe Admin::CategoryPolicy, type: :policy do
  subject { described_class }

  permissions :index?, :show?, :new?, :edit?, :create?,
              :update?, :move_items?, :update_items? do
    include_examples 'admin or higher user(with access)' do
      let(:record) { described_class }
    end

    include_examples 'standard user' do
      let(:record) { described_class }
    end
  end

  permissions :destroy? do
    let(:category) { create :category }

    context 'with items' do
      before { create_list :item, 10, category: category }

      include_examples 'admin or higher user(without access)' do
        let(:record) { category }
      end
    end

    context 'without items' do
      include_examples 'admin or higher user(with access)' do
        let(:record) { category }
      end
    end

    include_examples 'standard user' do
      let(:record) { category }
    end
  end
end
