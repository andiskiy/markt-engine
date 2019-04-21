require 'rails_helper'

RSpec.describe User::Roles, type: :model do
  let(:super_users)    { create_list :super_user, 10 }
  let(:admin_users)    { create_list :admin, 10 }
  let(:standard_users) { create_list :standard, 10 }

  roles = User::ROLES
  User::ROLES.reverse_each do |role|
    let("#{role}_or_higher") { roles.map { |let_role| send("#{let_role}_users") } }
    roles -= [role]
  end

  roles = User::ROLES
  User::ROLES.each do |role|
    let("#{role}_or_lower") { roles.map { |let_role| send("#{let_role}_users") } }
    roles -= [role]
  end

  prev_roles = []
  User::ROLES.each do |role|
    it role do
      expect(User.send(role)).to eq_id_list_of(send("#{role}_users"))
    end

    it "#{role}_or_higher" do
      expect(User.send("#{role}_or_higher")).to eq_id_list_of(send("#{role}_or_higher"))
    end

    it "#{role}_or_lower" do
      expect(User.send("#{role}_or_lower")).to eq_id_list_of(send("#{role}_or_lower"))
    end

    context "when user role is '#{role}'" do
      let(:user) do
        user_role = role == 'super' ? 'super_user' : role
        create user_role
      end

      %w[? _or_higher? _or_lower?].each do |scope|
        it "#{role}#{scope}" do
          expect(user.send("#{role}?")).to be(true)
        end
      end

      (User::ROLES - [role]).each do |failed_role|
        it "#{failed_role}?" do
          expect(user.send("#{failed_role}?")).to be(false)
        end
      end

      prev_roles.each do |prev_role|
        it "#{prev_role}_or_higher?" do
          expect(user.send("#{prev_role}_or_higher?")).to be(false)
        end

        it "#{prev_role}_or_lower?" do
          expect(user.send("#{prev_role}_or_lower?")).to be(true)
        end
      end
      prev_roles << role

      (User::ROLES - prev_roles).each do |failed_role|
        it "#{failed_role}_or_higher?" do
          expect(user.send("#{failed_role}_or_higher?")).to be(true)
        end

        it "#{failed_role}_or_lower?" do
          expect(user.send("#{failed_role}_or_lower?")).to be(false)
        end
      end
    end
  end

  %w[admin standard].each do |role|
    context 'when user is super' do
      let(:user)  { create :super_user }

      it "#{role}!" do
        user.send("#{role}!")

        expect(user.reload.role).to eq('super')
      end

      it "#{role}_was?" do
        user.role = role

        expect(user.super_was?).to be(true)
      end
    end

    context "when user is #{role}" do
      let(:user)  { create role }

      it 'super!' do
        user.super!

        expect(user.reload.role).to eq(role)
      end

      opposite_role = { admin: 'standard', standard: 'admin' }
      it "#{opposite_role[role.to_sym]}!" do
        user.send("#{opposite_role[role.to_sym]}!")

        expect(user.reload.role).to eq(opposite_role[role.to_sym])
      end

      it "#{role}_was?" do
        user.role = opposite_role[role.to_sym]

        expect(user.send("#{role}_was?")).to be(true)
      end
    end
  end
end
