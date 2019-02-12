module AwsResources
  def s3
    @s3 ||= Aws::S3::Resource.new
  end

  def self.included(base)
    base.send(:extend, ClassMethods)
  end

  module ClassMethods
    def s3_bucket
      "#{ENV['AWS_S3_BUCKET']}-#{Rails.env}"
    end
  end
end
