shared_examples 'categories and purchase' do
  let(:second_category) { create :category }
  let(:first_category) { create :category }
  let!(:categories) do
    categories_temp = create_list :category, Category::PER_PAGE + 10
    (categories_temp << first_category << second_category).sort_by(&:name)
  end

  include_examples 'authorized'
  include_examples 'not authorized'

  it 'categories assigns' do
    http_request
    expect(assigns(:categories)).to eq(categories)
  end
end

shared_examples 'authorized' do
  context 'when user is authorized' do
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

shared_examples 'not authorized' do
  context 'when user is not authorized' do
    it 'purchase assigns' do
      http_request
      expect(assigns(:purchase)).to be_nil
    end

    it 'was not created purchase' do
      expect { http_request }.to change(Purchase, :count).by(0)
    end
  end
end
