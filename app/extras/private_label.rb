require 'singleton'

class PrivateLabel
  include Singleton

  def setup( territory = nil )
    @territory = territory

    if territory && territory.private_label
      @label = ChamberPrivateLabel.new( territory )
    else
      @label = RelyLocalLabel.new( territory )
    end
  end

  def site_name
    @label.site_name
  end

  def default_logo
    @label.default_logo
  end

  def header_name
    @territory.brand_name.blank? ? @territory.name : @territory.brand_name
  end

  def private_label_mode
    @label.private_label_mode
  end

end

class RelyLocalLabel

  def initialize( territory )
    @territory = territory
  end

  def site_name
    @territory.brand_name.blank? ? "RelyLocal" : @territory.brand_name
  end

  def default_logo
    "/images/defaults/normal_logo.png"
  end

  def private_label_mode
    false
  end
end

class ChamberPrivateLabel

  def initialize( territory )
    @territory = territory
  end

  def site_name
    @territory.brand_name
  end

  def default_logo
    @territory.brand_default_logo.url(:normal)
  end

  def private_label_mode
    true
  end
end
