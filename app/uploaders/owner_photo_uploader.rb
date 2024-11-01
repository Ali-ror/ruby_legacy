# encoding: utf-8
class OwnerPhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::RelyLocal::Customization
  storage :file
  
  version :normal do
    process :resize_to_fit => [140, 160]
  end

  # for image size validation
  # fetching dimensions in uploader, validating it in model
  before :cache, :capture_size_before_cache # callback, example here: http://goo.gl/9VGHI
  def capture_size_before_cache(new_file)
    model.owner_photo_upload_width, model.owner_photo_upload_height = `identify -format "%wx %h" #{new_file.file.tempfile.path}`.split(/x/).map { |dim| dim.to_i }
  end

end