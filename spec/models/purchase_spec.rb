require 'rails_helper'

RSpec.describe Purchase, type: :model do
  let(:user)     { create :user }
  let(:orders)   { create_list :order, 10, purchase: purchase, user: user }
  let(:purchase) { create :pending_purchase, user: user }

  describe 'countryable' do
    include_examples 'countryable' do
      let(:model) { purchase }
    end
  end

  describe 'associations' do
    before { orders }

    it 'user' do
      expect(purchase.user).to eq(user)
    end

    it 'with_deleted_user' do
      user.destroy
      expect(purchase.with_deleted_user).to eq(user)
    end

    it 'orders' do
      expect(purchase.orders).to eq(orders)
    end
  end

  describe 'validations' do
    it 'pending purchase valid' do
      expect(build(:pending_purchase)).to be_valid
    end

    it 'completed purchase valid' do
      expect(build(:completed_purchase)).to be_valid
    end

    context 'when processing purchase' do
      %w[country_code address city zip_code phone].each do |field|
        it "#{field} presence" do
          expect(build(:processing_purchase, "#{field}": nil)).not_to be_valid
        end
      end
    end
  end

  describe 'callbacks' do
    it 'not update ordered_at when create pending purchase' do
      expect(purchase.ordered_at).to be_nil
    end

    it 'set_ordered_at' do
      purchase.processing!
      expect(purchase.ordered_at).not_to be_nil
    end
  end

  describe 'scopes' do
    let(:pending_purchase)    { create :pending_purchase }
    let(:completed_purchase)  { create :completed_purchase }
    let(:processing_purchase) { create :processing_purchase }
    let!(:purchases) do
      orders
      user_temp = create :user
      create :order, purchase: processing_purchase, user: user_temp
      create :order, purchase: completed_purchase, user: user_temp
      [purchase, processing_purchase, completed_purchase].sort_by(&:created_at)
    end
    let(:additional_purchases) do
      [create(:pending_purchase),
       create(:processing_purchase),
       create(:completed_purchase)]
    end

    before do
      item_temp = create :item
      user_temp = create :user
      create :order, purchase: pending_purchase, item: item_temp, user: user_temp
      item_temp.destroy
    end

    it 'with_orders' do
      additional_purchases
      expect(described_class.with_orders).to eq(purchases)
    end

    it 'with_status(all)' do
      additional_purchases
      expect(described_class.with_status('')).to eq((purchases << pending_purchase) + additional_purchases)
    end

    it 'with_status(processing)' do
      expect(described_class.with_status('processing')).to eq([processing_purchase])
    end

    it 'with_status(completed)' do
      expect(described_class.with_status('completed')).to eq([completed_purchase])
    end
  end

  describe 'methods' do
    let(:first_item)      { create :item, price: first_price }
    let(:second_item)     { create :item, price: second_price }
    let(:full_amount)     { first_price * first_quantity + second_price * second_quantity }
    let(:first_price)     { 10 }
    let(:second_price)    { 30 }
    let(:first_quantity)  { 1 }
    let(:second_quantity) { 2 }

    let(:orders) do
      create :order, purchase: purchase, item: first_item, user: user, quantity: first_quantity
      create :order, purchase: purchase, item: second_item, user: user, quantity: second_quantity
    end

    it 'amount_with_deleted_items(pending purchase)' do
      orders
      first_item.destroy
      expect(purchase.amount_with_deleted_items).to eq(second_quantity * second_price)
    end

    it 'amount_with_deleted_items(processing purchase)' do
      purchase.processing!
      orders
      second_item.destroy
      expect(purchase.amount_with_deleted_items).to eq(full_amount)
    end

    it 'amount_items(without deleted items)' do
      orders
      expect(purchase.amount_items).to eq(full_amount)
    end

    it 'amount_items(with deleted items)' do
      orders
      second_item.destroy
      expect(purchase.amount_items).to eq(first_price * first_quantity)
    end

    it 'datetime_format returns N/A' do
      expect(purchase.datetime_format(nil)).to eq('N/A')
    end

    it 'datetime_format returns true date' do
      time = Time.current
      expect(purchase.datetime_format(time)).to be_datetime_format(time)
    end

    it 'ordered_date ordered_at is null' do
      expect(purchase.ordered_date.change(usec: 0)).to eq(Time.now.utc.change(usec: 0))
    end

    it 'ordered_date ordered_at is not null' do
      purchase.processing!
      expect(purchase.ordered_date).to eq(purchase.ordered_at.in_time_zone('UTC'))
    end

    Purchase::STATUSES.each do |status|
      context "when purchase is #{status}" do
        let(:purchase) { create "#{status}_purchase", user: user, ordered_at: 10.seconds.ago }

        it "#{status}?" do
          expect(purchase.send("#{status}?")).to be(true)
        end
      end
    end

    it 'processing?(purchase is pending)' do
      expect(purchase.processing?).to be(false)
    end

    it 'processing!(purchase is pending)' do
      purchase.processing!
      expect(purchase.processing?).to be(true)
    end

    it 'completed!(purchase is processing)' do
      purchase.processing!
      purchase.completed!
      expect(purchase.completed?).to be(true)
    end
  end
end
