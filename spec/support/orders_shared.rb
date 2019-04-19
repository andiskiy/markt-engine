shared_examples 'search_with_deleted' do
  let(:date) { purchase.ordered_date }

  it 'search by old name(item name not changed) #search_with_deleted' do
    expect(described_class.search_with_deleted(old_name, date)).to eq_id_list_of([order])
  end

  it 'search by old name(item name changed) #search_with_deleted' do
    update_item
    expect(described_class.search_with_deleted(old_name, date)).to eq_id_list_of(old_name_item_changed)
  end

  it 'search by new name(item name changed) #search_with_deleted' do
    update_item
    expect(described_class.search_with_deleted(new_name, date)).to eq_id_list_of(new_name_item_changed)
  end
end
