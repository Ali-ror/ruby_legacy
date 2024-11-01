# encoding: utf-8
class LegacyCouponUploader < CarrierWave::Uploader::Base
  include CarrierWave::RelyLocal::Customization
  storage :file
end