require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user)           { create :user, first_name: old_first_name, last_name: old_last_name, email: old_email }
  let(:old_email)      { 'email@gmail.com' }
  let(:new_email)      { 'new_email@gmail.com' }
  let(:old_last_name)  { 'Doe' }
  let(:new_last_name)  { 'New Doe' }
  let(:old_first_name) { 'John' }
  let(:new_first_name) { 'New John' }

  describe 'versionable' do
    before { user.update(first_name: new_first_name, last_name: new_last_name, email: new_email) }

    include_examples 'versionable', %w[first_name last_name email] do
      let(:model) { user }
    end
  end

  describe 'countryable' do
    include_examples 'countryable' do
      let(:model) { user }
    end
  end

  describe 'associations' do
    let(:items)     { create_list :item, 10 }
    let(:purchases) { create_list :purchase, 20, user: user }
    let(:orders) do
      user_temp = create :user
      first_purchase_temp = create :pending_purchase, user: user
      second_purchase_temp = create :pending_purchase, user: user
      items.each do |item|
        create :order, user: user_temp, purchase: first_purchase_temp, item: item
      end
      first_orders_temp = items.map do |item|
        create :order, user: user, purchase: first_purchase_temp, item: item
      end
      second_orders_temp = items.map do |item|
        create :order, user: user, purchase: second_purchase_temp, item: item
      end
      first_orders_temp + second_orders_temp
    end

    it 'orders' do
      orders
      expect(user.orders).to eq_id_list_of(orders)
    end

    it 'items' do
      orders
      expect(user.items).to eq_id_list_of(items + items)
    end

    it 'purchases' do
      purchases
      expect(user.purchases).to eq_id_list_of(purchases)
    end
  end

  describe 'validations' do
    %w[first_name last_name].each do |field|
      it "#{field} presence" do
        expect(build(:user, "#{field}": nil)).not_to be_valid
      end
    end

    it 'first_name and last_name presence' do
      expect(build(:user, first_name: 'first name', last_name: 'last name')).to be_valid
    end

    it 'role inclusion(bad role)' do
      expect(build(:user, role: 'bad')).not_to be_valid
    end

    it 'role inclusion' do
      expect(build(:user, role: 'standard')).to be_valid
    end

    %w[admin standard].each do |role|
      it "do_not_allow_super_role(#{role} to super)" do
        user_temp = create role

        expect(user_temp.super!).to be(false)
      end

      it "do_not_allow_super_role(super to #{role})" do
        user_temp = create :super_user

        expect(user_temp.send("#{role}!")).to be(false)
      end
    end

    it 'do_not_allow_super_role error message(standard to super)' do
      user.super!
      error_message = I18n.t('activerecord.errors.models.user.attributes.role.update_another_role_to_super')
      expect(user.errors.messages[:role]).to eq([error_message])
    end

    it 'do_not_allow_super_role error message(super to admin)' do
      user_temp = create :super_user
      user_temp.admin!
      error_message = I18n.t('activerecord.errors.models.user.attributes.role.update_super_role_to_another')
      expect(user_temp.errors.messages[:role]).to eq([error_message])
    end
  end

  describe 'scopes' do
    let(:users)          { (admin_users + standard_users) }
    let(:email)          { 'AAAAAAAA@gmail.com' }
    let(:last_name)      { '444AAAAAAAAXXXXXX' }
    let(:super_user)     { create :super_user, first_name: first_name, last_name: last_name }
    let(:first_name)     { '111AAAAAAAAWWWWWW' }
    let(:first_user)     { create :user, first_name: first_name, last_name: 'RRRRRR' }
    let(:third_user)     { create :user, email: email }
    let(:second_user)    { create :user, last_name: last_name }
    let(:admin_users)    { create_list :admin, 20 }
    let(:standard_users) { create_list :user, 20 }
    let(:search) do
      users
      first_user
      second_user
      third_user
    end

    it 'order_by_id' do
      users
      expect(described_class.order_by_id).to eq(users)
    end

    it 'with_role(all)' do
      users
      expect(described_class.with_role('')).to eq_id_list_of(users)
    end

    it 'with_role(super)' do
      users
      expect(described_class.with_role('super')).to eq([])
    end

    it 'with_role(admin)' do
      users
      expect(described_class.with_role('admin')).to eq_id_list_of(admin_users)
    end

    it 'with_role(standard)' do
      users
      expect(described_class.with_role('standard')).to eq_id_list_of(standard_users)
    end

    it 'search all three users' do
      search
      expect(described_class.search('AAAAAAAA')).to eq_id_list_of([first_user, second_user, third_user])
    end

    it 'search by full name' do
      search
      expect(described_class.search('WWWWWW RRRRRR')).to eq_id_list_of([first_user])
    end

    it 'search by first name' do
      search
      expect(described_class.search(first_name)).to eq_id_list_of([first_user])
    end

    it 'search by last name' do
      search
      expect(described_class.search(last_name)).to eq_id_list_of([second_user])
    end

    it 'search by email' do
      search
      expect(described_class.search(email)).to eq_id_list_of([third_user])
    end
  end

  describe 'methods' do
    let(:update_user_info) { user.update(first_name: new_first_name, last_name: new_last_name, email: new_email) }

    it 'full_name' do
      expect(user.full_name).to eq("#{old_first_name} #{old_last_name}")
    end

    it 'full_name_with_email(old name)' do
      update_user_info
      time = 10.seconds.ago
      expect(user.full_name_with_email(time)).to eq("#{old_first_name} #{old_last_name} (#{old_email})")
    end

    it 'full_name_with_email(new name)' do
      update_user_info
      time = 10.seconds.from_now
      expect(user.full_name_with_email(time)).to eq("#{new_first_name} #{new_last_name} (#{new_email})")
    end
  end
end
