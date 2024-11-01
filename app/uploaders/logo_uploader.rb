# encoding: utf-8
class LogoUploader < CarrierWave::Uploader::Base
  include CarrierWave::RelyLocal::Customization
  storage :file

  version :normal do
    process :resize_to_limit => [140, 72]
  end

  version :partner do
    process :resize_to_limit => [70, 52]
  end

  def default_url
    if model.respond_to?( :territory ) && model.territory.present? && model.territory.private_label
      model.territory.brand_default_logo.url( :normal )
    else
      "/images/defaults/" + [version_name, "logo.png"].compact.join('_')
    end
  end
end
