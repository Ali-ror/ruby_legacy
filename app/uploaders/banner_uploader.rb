# encoding: utf-8
class BannerUploader < CarrierWave::Uploader::Base
  include CarrierWave::RelyLocal::Customization
  storage :file
  
  version :small do
    process :resize_to_limit => [140, 140]
  end
  
  version :w300 do
    process :resize_to_fill => [300, 140]
  end
  
  version :w140 do
    process :resize_to_fill => [140, 140]
  end
  
  version :large do
    process :resize_to_limit => [400, 140]
  end
end