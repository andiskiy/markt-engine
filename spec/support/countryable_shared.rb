shared_examples 'countryable' do
  let(:locale_ru) { I18n.locale = :ru }
  let(:locale_en) { I18n.locale = :en }

  it 'full_address when all fields are filled' do
    t = model
    expect(model.full_address).to eq([t.address, t.city, t.country, t.zip_code].join(', '))
  end

  it 'full_address when one of the fields is empty' do
    model.update(address: nil)
    expect(model.full_address).to eq(I18n.t('admin.user.messages.no_address'))
  end

  it 'country' do
    locale_en
    expect(model.country).to eq('United States')
  end

  it 'priority_countries(RU)' do
    locale_ru
    expect(model.priority_countries).to eq(['ru'])
  end

  it 'priority_countries(EN)' do
    locale_en
    expect(model.priority_countries).to eq(%w[GB US])
  end

  context 'when country_code is empty' do
    before { model.update(country_code: nil) }

    it 'country' do
      expect(model.country).to be_nil
    end
  end
end
