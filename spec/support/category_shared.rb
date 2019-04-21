shared_examples 'set categories' do
  let(:second_category) { create :category }
  let(:first_category) { create :category }
  let!(:categories) do
    categories_temp = create_list :category, Category::PER_PAGE + 10
    (categories_temp << first_category << second_category)
  end

  it 'categories assigns' do
    http_request
    expect(assigns(:categories)).to eq_id_list_of(categories)
  end
end
