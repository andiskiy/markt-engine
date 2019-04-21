class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  after :remove, :destroy_model

  def fog_public
    false
  end

  def fog_authenticated_url_expiration
    1.hour
  end

  def store_dir
    "uploads/items/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumb do
    process resize_to_fit: [250, 300]
  end

  def extension_whitelist
    %w[jpg jpeg gif png]
  end

  def content_type_whitelist
    %r{image\/}
  end

  private

  def destroy_model
    model.destroy
  end
end
