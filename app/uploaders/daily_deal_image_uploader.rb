class DailyDealImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RelyLocal::Customization
  storage :file
  
  version :normal do
    process :resize_to_fit => [220, 145]
  end  
  
  version :medium do
    process :resize_and_pad => [300, 99]
  end

  version :large do
    process :resize_and_pad => [440, 145]
  end
  
  def dimensions(version=nil)
    path = version.blank? ? self.path : self.send(version.to_s).path
    begin
      image = MiniMagick::Image.open(path)
      return { :width => image[:width].to_i, :height => image[:height].to_i }
    rescue
      return { :width => 220, :height => 145 }
    end
  end
end