shared_examples 'search_with_deleted' do
  it 'search by old name(item name not changed) #search_with_deleted' do
    expect(described_class.search_with_deleted(old_name, purchase.ordered_date)).to eq([order])
  end

  it 'search by old name(item name changed) #search_with_deleted' do
    update_item
    expect(described_class.search_with_deleted(old_name, purchase.ordered_date)).to eq(old_name_item_changed)
  end

  it 'search by new name(item name changed) #search_with_deleted' do
    update_item
    expect(described_class.search_with_deleted(new_name, purchase.ordered_date)).to eq(new_name_item_changed)
  end
end
