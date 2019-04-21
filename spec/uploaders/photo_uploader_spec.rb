require 'carrierwave/test/matchers'
require 'rails_helper'

RSpec.describe PhotoUploader do
  include CarrierWave::Test::Matchers

  let(:uploader)     { described_class.new(item_photo, :photo) }
  let(:item_photo)   { create :item_photo }
  let(:path_to_file) { Rails.root.join('spec', 'fixtures', 'myfiles', 'test.jpg') }

  before do
    described_class.enable_processing = true
    File.open(path_to_file) { |f| uploader.store!(f) }
  end

  after do
    described_class.enable_processing = false
    uploader.remove!
  end

  it 'thumb version scales down a landscape image to be exactly 250 by 300 pixels' do
    expect(uploader.thumb).to be_no_larger_than(250, 300)
  end

  it 'has the correct format' do
    expect(uploader).to be_format('jpeg')
  end

  it 'extension_white_list' do
    expect(uploader.extension_whitelist).to eq(%w[jpg jpeg gif png])
  end

  it 'content_type_whitelist' do
    expect(uploader.content_type_whitelist).to eq(%r{image\/})
  end

  it 'destroy_model' do
    expect { item_photo.remove_photo! }.to change(ItemPhoto, :count).by(-1)
  end
end
