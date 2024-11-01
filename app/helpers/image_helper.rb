module ImageHelper
  def get_dimensions_of(image_path)
    image  = MiniMagick::Image.open(image_path)
    return { :width => image[:width].to_i, :height => image[:height].to_i }
  rescue
    return { :width => 0, :height => 0 }
  end
  
  def coupon_truncation(coupon)
    dimensions = coupon.get_dimensions(:normal)
    
    return 120 if dimensions[:height] < 115
    return 75  if coupon.title.length <= 24
    return 40
  rescue
    return 40
  end
end