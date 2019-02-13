CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
    region:                ENV['AWS_REGION'],
    provider:              'AWS',
    aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
  }

  config.fog_directory = "#{ENV['AWS_S3_BUCKET']}-#{Rails.env}"
end
