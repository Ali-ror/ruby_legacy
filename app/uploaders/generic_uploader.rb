# encoding: utf-8

class GenericUploader < CarrierWave::Uploader::Base
  include CarrierWave::RelyLocal::Customization

  # Include RMagick or ImageScience support:
  # include CarrierWave::RMagick
  # include CarrierWave::ImageScience



  #def store_dir
  #  if self.model.updated_at >= CUTOFF
  #    CarrierWave::RelyLocal::Customization.store_dir
  #  else
  #    "uploads"
  #  end
  #end



  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :s3

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # def filename
  #   "something.jpg" if original_filename
  # end

end
