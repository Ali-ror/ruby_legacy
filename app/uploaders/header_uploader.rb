# encoding: utf-8
class HeaderUploader < CarrierWave::Uploader::Base
  include CarrierWave::RelyLocal::Customization
  storage :file
  
  version :small do
    process :resize_to_fill => [300, 54]
  end
  
  version :normal do
    process :resize_to_fill => [1000, 180]
  end
end