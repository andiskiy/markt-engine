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
    it 'purchase assigns' do
      http_request
      expect(assigns(:purchase)).to be_nil
    end

    it 'was not created purchase' do
      expect { http_request }.to change(Purchase, :count).by(0)
    end
  end
end
