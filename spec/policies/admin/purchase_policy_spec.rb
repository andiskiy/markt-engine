require 'rails_helper'

RSpec.describe Admin::PurchasePolicy, type: :policy do
  subject { described_class }

  permissions :index?, :destroy? do
    include_examples 'admin or higher user(with access)' do
      let(:record) { described_class }
    end

    include_examples 'standard user' do
      let(:record) { described_class }
    end
  end

  permissions :complete? do
    context 'with processing purchase' do
      include_examples 'admin or higher user(with access)' do
        let(:record) { create :processing_purchase }
      end
    end

    %w[pending_purchase completed_purchase].each do |purchase|
      context 'without orders' do
        include_examples 'admin or higher user(without access)' do
          let(:record) { create purchase }
        end
      end
    end

    include_examples 'standard user' do
      let(:record) { create :processing_purchase }
    end
  end
end
