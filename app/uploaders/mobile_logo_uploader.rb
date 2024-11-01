# encoding: utf-8
class MobileLogoUploader < CarrierWave::Uploader::Base
  include CarrierWave::RelyLocal::Customization
  storage :file
  
  version :normal do
    process :resize_to_limit => [114, 114]
  end
  
  def default_url
    "/images/defaults/mobile_logo.png"
  end

  # for image size validation
  # fetching dimensions in uploader, validating it in model
  before :cache, :capture_size_before_cache # callback, example here: http://goo.gl/9VGHI
  def capture_size_before_cache(new_file)
    #Rails.logger.debug "-------------------------------------capture_size"
    #Rails.logger.debug new_file.file.tempfile.path.inspect
    #Rails.logger.debug new_file.path.inspect
    #Rails.logger.debug `identify -format "%wx %h" #{new_file.path}`.inspect
    #Rails.logger.debug `identify -format "%wx %h" #{new_file.file.tempfile.path}`.inspect
    #Rails.logger.debug `identify -format "%wx %h" #{new_file.file.tempfile.path}`.split(/x/).map { |dim| dim.to_i }.inspect
    #if model.mobile_logo_upload_width.nil? || model.mobile_logo_upload_height.nil?
    model.mobile_logo_upload_width, model.mobile_logo_upload_height = `identify -format "%wx %h" #{new_file.file.tempfile.path}`.split(/x/).map { |dim| dim.to_i }
    #end
  end

end