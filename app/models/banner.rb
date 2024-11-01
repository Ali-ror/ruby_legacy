# == Schema Information
#
# Table name: banners
#
#  id           :integer(4)      not null, primary key
#  territory_id :integer(4)
#  active       :boolean(1)
#  created_at   :datetime
#  updated_at   :datetime
#  link         :string(255)
#  size         :string(255)
#  banner       :string(255)
#

class Banner < ActiveRecord::Base
  mount_uploader :banner, BannerUploader

  belongs_to :territory

  after_update :validate_dimensions
  before_save  :normalize_link

  VALID_SIZES = [ "140x140", "300x140" ]

  validates :banner, :presence => true
  validates :size, :presence => true

  LOCATIONS = [ "Top Wide - 300x140", "Bottom Wide - 300x140",
                "Top Left - 140x140", "Top Right - 140x140", "Bottom Left - 140x140", "Bottom Right - 140x140" ]

  scope :active,  where(:active => true)
  scope :wide,    where(:size => "300x140")
  scope :narrow,  where(:size => "140x140")
  scope :random,  order("RAND()")

  scope :has_location, lambda { |location| where( 'location_mask & ?', 2**LOCATIONS.index( location.to_s ) ) }

  def banner_image_url
    case size
    when "140x140"
      self.banner.url(:w140)
    else
      self.banner.url(:w300)
    end
  end

  def normalize_link
    unless link.blank?
      url = link.nil? ? self.link : link
      url = link.gsub(",","--")
      uri = URI.parse(url)
      uri = URI.parse("http://#{uri}") unless uri.scheme
      uri.scheme = uri.scheme.downcase  # URI should do this
      self.link = uri.normalize.to_s.gsub("--",",")
    end
  end

  def locations=(ls)
    self.location_mask = 0 if ls.empty?
    self.location_mask = ( ls & LOCATIONS ).map{ |r| 2**LOCATIONS.index( r ) }.inject( 0, :+ ) if !ls.empty?
  end

  def locations
    return [] if location_mask.nil?

    LOCATIONS.reject do |r|
      ( ( location_mask.to_i || 0 ) & 2**LOCATIONS.index( r ) ).zero?
    end
  end

  def in_location?( location )
    locations.include? location.to_s
  end

  private

  def validate_dimensions
    if banner.path
      image  = MiniMagick::Image.open(banner.path)
      width  = image[:width]
      height = image[:height]

      image_size = "#{width}x#{height}"
      if image_size != size
        Postoffice.banner_wrong_size( self, image_size ).deliver
      end
    end
  end

end
