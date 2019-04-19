require 'carrierwave/storage/fog'

if Rails.env.test?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end

  [PhotoUploader].each do |klass|
    next if klass.anonymous?

    klass.class_eval do
      def cache_dir
        Rails.root.join('spec', 'support', 'uploads', 'tmp')
      end

      def store_dir
        "#{Rails.root}/spec/support/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
      end
    end
  end
else
  CarrierWave.configure do |config|
    config.storage = :file
  end
end
