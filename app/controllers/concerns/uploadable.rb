# frozen_string_literal: true

module Uploadable
  extend ActiveSupport::Concern

  def upload
    key = File.basename(file_path)
    s3 = Aws::S3::Resource.new(region: 'us-east-1')
    obj = s3.bucket(ENV.fetch('AWS_BUCKET')).object(key)
    obj.upload_file(file_path)
    obj.public_url
  end
end
