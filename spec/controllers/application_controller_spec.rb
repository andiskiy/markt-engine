require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe '#admin_user!' do
    controller do
      before_action :admin_user!

      def index
        head :ok
      end
    end

    let(:http_request) { get :index }

    %w[admin super_user].each do |user_role|
      context "when user is #{user_role}" do
        send("login_#{user_role}")

        it 'does not redirect' do
          http_request
          expect(response).not_to redirect_to(root_path)
        end
      end
    end

    context 'when user is standard' do
      login_user

      it 'redirect to' do
        http_request
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is not authorized' do
      it 'redirect to' do
        http_request
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
