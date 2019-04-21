require 'rails_helper'

RSpec.describe Admin::UserPolicy, type: :policy do
  subject { described_class }

  permissions :index? do
    include_examples 'admin or higher user(with access)' do
      let(:record) { described_class }
    end

    include_examples 'standard user' do
      let(:record) { described_class }
    end
  end

  permissions :show?, :update?, :destroy? do
    %w[admin standard].each do |role|
      context "with user role #{role.upcase}" do
        include_examples 'admin or higher user(with access)' do
          let(:record) { create role }
        end
      end
    end

    context 'with user role SUPER' do
      include_examples 'admin or higher user(without access)' do
        let(:record) { create :super_user }
      end
    end

    include_examples 'standard user' do
      let(:record) { create :standard }
    end
  end

  permissions :update?, :destroy? do
    %w[admin super_user].each do |role|
      context "with user role #{role.upcase}" do
        include_examples 'admin or higher user(without access)' do
          let(:user)   { create role }
          let(:record) { user }
        end
      end
    end

    include_examples 'standard user' do
      let(:record) { create :standard }
    end
  end
end
