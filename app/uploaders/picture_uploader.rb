# encoding: utf-8
class PictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::RelyLocal::Customization
  storage :file
  
  version :normal do
    process :resize_to_fit => [600, nil]
  end  
end