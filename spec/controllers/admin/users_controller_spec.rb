require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  describe 'GET admin/index' do
    let(:user)            { create :user, first_name: first_name, last_name: last_name, email: email }
    let(:admin)           { create :admin }
    let(:email)           { 'email@email.com' }
    let(:last_name)       { 'Last' }
    let(:first_name)      { 'First' }
    let(:http_request)    { get :index }
    let!(:standard_users) { create_list :user, User::PER_PAGE }

    %w[admin super_user].each do |user_role|
      context "when user is #{user_role}" do
        send("login_#{user_role}")

        let!(:admin_users) do
          admins = create_list :admin, 10
          subject.current_user.admin? ? admins.unshift(subject.current_user) : admins << admin
        end
        let!(:users)          { standard_users + admin_users }
        let(:http_request_js) { get :index, xhr: true }

        it 'get users from first page' do
          http_request
          expect(assigns(:users)).to eq(users[0..(User::PER_PAGE - 1)])
        end

        it 'get users from second page' do
          get :index, params: { page: 2 }
          expect(assigns(:users)).to eq(users[User::PER_PAGE..(User::PER_PAGE + 11)])
        end

        %w[email last_name first_name].each do |search_filed|
          it "get users by search #{search_filed.sub('_', ' ')}" do
            user
            get :index, params: { value: send(search_filed) }
            expect(assigns(:users)).to eq([user])
          end
        end

        %w[admin standard].each do |role|
          it "get users with role #{role}" do
            users_list = send("#{role}_users")
            get :index, params: { role: role }
            expect(assigns(:users)).to eq(users_list[0..(User::PER_PAGE - 1)])
          end
        end

        include_examples 'render partial js', 'admin/users/_users_list'
      end
    end

    include_examples 'no access to admin panel'
  end

  describe 'GET admin/show' do
    let(:user)         { create :user }
    let(:http_request) { get :show, params: { id: user } }

    %w[admin super_user].each do |user_role|
      context "when user is #{user_role}" do
        send("login_#{user_role}")

        %w[admin user].each do |role|
          context "and see info user with the role #{role}" do
            let!(:user) { create role }

            it 'user assigns' do
              http_request
              expect(assigns(:user)).to eq(user)
            end
          end
        end

        context 'and see info about the super user' do
          let!(:user) { create :super_user }

          it 'access denied' do
            expect(http_request).to render_template('users/sessions/access_denied')
          end
        end
      end
    end

    include_examples 'no access to admin panel'
  end

  describe 'PATCH admin/update' do
    let(:user)         { create :user }
    let(:new_role)     { 'admin' }
    let(:http_request) { patch :update, params: { id: user, role: new_role } }

    %w[admin super_user].each do |user_role|
      context "when user is #{user_role}" do
        send("login_#{user_role}")

        let(:http_request_json) { patch :update, params: { id: user, role: new_role }, format: 'json' }

        %w[admin standard].each do |role|
          roles = { admin: 'standard', standard: 'admin' }

          context "and change role from #{role} to #{roles[role.to_sym]}" do
            let!(:user)    { create role }
            let(:new_role) { roles[role.to_sym] }

            it 'response status' do
              http_request
              expect(response.status).to eq(302)
            end

            it 'success' do
              http_request
              expect(assigns(:user).role).to eq(new_role)
            end

            it 'sets flash success' do
              expect(http_request.request.flash[:success]).to eq(I18n.t('admin.user.flash_messages.update.success'))
            end

            include_examples 'sets status json', 'updated'

            it 'check created item name when format json' do
              http_request_json
              expect(JSON.parse(response.body)['user']['role']).to eq(new_role)
            end
          end

          context "and can't change role" do
            let!(:user)    { create role }
            let(:new_role) { 'super' }

            it "'super' role failed" do
              error_message = I18n.t('activerecord.errors.models.user.attributes.role.update_super_role')
              http_request
              expect(assigns(:user).errors.messages[:role]).to eq([error_message])
            end

            it "'bad' role failed" do
              error_message = I18n.t('activerecord.errors.models.user.attributes.role.inclusion')
              patch :update, params: { id: user, role: 'bad' }
              expect(assigns(:user).errors.messages[:role]).to eq([error_message])
            end

            it 'sets flash danger' do
              expect(http_request.request.flash[:danger]).to eq(I18n.t('admin.user.flash_messages.update.danger'))
            end

            include_examples 'sets status json', 'unprocessable_entity'
          end
        end

        context "and can't change the role of yourself" do
          let!(:user)    { subject.current_user }
          let(:new_role) { 'standard' }

          it 'access denied' do
            expect(http_request).to render_template('users/sessions/access_denied')
          end
        end
      end
    end

    include_examples 'no access to admin panel'
  end

  describe 'DELETE admin/destroy' do
    let(:user)         { create :user }
    let(:http_request) { delete :destroy, params: { id: user } }

    %w[admin super_user].each do |user_role|
      context "when user is #{user_role}" do
        send("login_#{user_role}")

        let(:http_request_json) { delete :destroy, params: { id: user }, format: 'json' }

        %w[admin standard].each do |role|
          context 'and you can delete users' do
            let!(:user) { create role }

            it { expect(http_request).to redirect_to(admin_users_path) }

            it { expect { http_request }.to change(User, :count).by(-1) }

            it 'sets flash success' do
              expect(http_request.request.flash[:success]).to eq(I18n.t('admin.user.flash_messages.delete.success'))
            end

            include_examples 'sets status json', 'deleted'
          end
        end

        context 'and you cannot delete super user' do
          let!(:user) { create :super_user }

          it 'access denied' do
            expect(http_request).to render_template('users/sessions/access_denied')
          end
        end

        context 'and you cannot delete yourself' do
          let!(:user) { subject.current_user }

          it 'access denied' do
            expect(http_request).to render_template('users/sessions/access_denied')
          end
        end
      end
    end

    include_examples 'no access to admin panel'
  end
end
