require "shrine/storage/s3"
require "shrine/storage/memory"

s3_options = {
  access_key_id:     Rails.application.secrets.aws_access_key_id,
  secret_access_key: Rails.application.secrets.aws_secret_access_key,
  region:            Rails.application.secrets.aws_region,
  bucket:            Rails.application.secrets.aws_bucket
}

if Rails.env.test?
  Shrine.storages = {
    cache: Shrine::Storage::Memory.new,
    store: Shrine::Storage::Memory.new,
  }
else
  Shrine.storages = {
    cache: Shrine::Storage::S3.new(prefix: "cache", upload_options: {acl: "public-read"}, **s3_options),
    store: Shrine::Storage::S3.new(prefix: "store", upload_options: {acl: "public-read"}, **s3_options),
  }
end

Shrine.plugin :activerecord
Shrine.plugin :direct_upload
Shrine.plugin :restore_cached_data
