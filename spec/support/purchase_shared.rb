shared_examples 'set purchase' do
  include_examples 'set purchase when authorized'
  include_examples 'set purchase when not authorized'
end

shared_examples 'set purchase when authorized' do
  context 'when user is authorized for purchase' do
    login_user

    let(:current_user)     { subject.current_user }
    let(:pending_purchase) { create :pending_purchase, user: current_user }

    it 'purchase assigns' do
      pending_purchase
      http_request
      expect(assigns(:purchase)).to eq(pending_purchase)
    end

    it 'exists purchase' do
      pending_purchase
      expect { http_request }.to change(Purchase, :count).by(0)
    end

    it 'created purchase' do
      expect { http_request }.to change(Purchase, :count).by(1)
    end
  end
end

shared_examples 'set purchase when not authorized' do
  context 'when user is not authorized for purchase' do
    include_examples 'purchase to be a nil'

    it 'was not created purchase' do
      expect { http_request }.to change(Purchase, :count).by(0)
    end
  end
end

shared_examples 'assigns purchase in purchases controller' do
  let!(:item)    { create :item, category: category }
  let(:category) { create :category }

  context 'when user is authorized for purchase assigns' do
    login_user

    let(:current_user) { subject.current_user }

    context 'and valid data' do
      let(:purchase) { create :pending_purchase, user: current_user }

      before { create :order, item: item, user: current_user, purchase: purchase }

      it 'assigns purchase' do
        http_request
        expect(assigns(:purchase)).to eq(purchase)
      end
    end

    context 'and invalid data' do
      context 'with pending purchase and without orders' do
        let(:purchase) { create :pending_purchase, user: current_user }

        include_examples 'purchase to be a nil'
      end

      context 'with pending purchase and with only deleted item' do
        let(:purchase) { create :pending_purchase, user: current_user }

        before do
          create :order, item: item, user: current_user, purchase: purchase
          item.destroy
        end

        include_examples 'purchase to be a nil'
      end

      context 'and purchase belongs to another user' do
        let(:user)     { create :user }
        let(:purchase) { create :pending_purchase, user: user }

        before { create :order, item: item, user: user, purchase: purchase }

        include_examples 'purchase to be a nil'
      end

      %w[processing completed].each do |status|
        context "with #{status} purchase and with orders" do
          let(:purchase) { create "#{status}_purchase", user: current_user }

          before { create :order, item: item, user: current_user, purchase: purchase }

          include_examples 'purchase to be a nil'
        end
      end
    end
  end

  context 'when user is not authorized for purchase assigns' do
    let(:user)     { create :user }
    let(:purchase) { create :pending_purchase, user: user }

    it 'redirect to' do
      http_request
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end

shared_examples 'purchase to be a nil' do
  it 'assigns purchase' do
    http_request
    expect(assigns(:purchase)).to be_nil
  end
end
