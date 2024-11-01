class LegacyListing < LegacyBase
  set_table_name "listing"
  set_primary_key "listing_id"
  belongs_to :member,
    :class_name => 'LegacyMember',
    :foreign_key => 'listing_member'
  has_many :files,
    :class_name  => 'LegacyListingFile',
    :foreign_key => 'listing_id'
  has_many :comments,
    :class_name  => 'LegacyListingComment',
    :foreign_key => 'comment_listing'
  has_many :photos,
    :class_name  => 'LegacyListingPhoto',
    :foreign_key => 'photo_listing'
  has_many :coupons,
    :class_name  => 'LegacyRlCoupon',
    :foreign_key => 'listing_id'
  has_many :categories,
    :class_name => 'LegacyCategory',
    :finder_sql => 'SELECT c.* FROM setup_category AS c
                     WHERE category_id IN (#{listing_category.split("-").reject {|r| r.empty?}.join(",")}) GROUP BY c.category_id'

  def migrate_mapping
    package_type_map = { 1 => 'Feeder Listings', 2 => "Paid Listings", 3 => "Non-Member Listings" }
    {
      :name => listing_title.strip,
      :package_type => package_type_map[listing_package],
      :expires => listing_date_expired,
      #:featured => listing_date_featured < Time.now,
      :featured_date => listing_date_featured,
      :operating_hours => listing_hours.strip,
      :phone => listing_phone.strip,
      :fax => listing_fax.strip,
      :skype => listing_messaging_skype.strip,
      :short_description => CGI.unescapeHTML( listing_brief_desc.strip ),
      :long_description => CGI.unescapeHTML( listing_full_desc ),
      :hide_address => (listing_hide_address == 'Y'),
      :hide_map     => (listing_hide_map == 'Y'),
      :email => listing_email.strip,
      :business_tier => '100% Local'
    }
  end

  def add_links
    l = []
    l << Link.new( :link_type => LinkType.find_by_name( "Website" ), :url => listing_website.strip ) unless listing_website.blank?
    l << Link.new( :link_type => LinkType.find_by_name( "Facebook" ), :url => listing_messaging_facebook.strip ) unless listing_messaging_facebook.blank?
    l << Link.new( :link_type => LinkType.find_by_name( "Twitter" ), :url => listing_messaging_twitter ) unless listing_messaging_twitter.blank?
    l << Link.new( :link_type => LinkType.find_by_name( "Blogger" ), :url => listing_messaging_blog ) unless listing_messaging_blog.blank?
    l << Link.new( :link_type => LinkType.find_by_name( "LinkedIn" ), :url => listing_messaging_linkedin ) unless listing_messaging_linkedin.blank?
    l << Link.new( :link_type => LinkType.find_by_name( "YouTube" ), :url => listing_messaging_youtube ) unless listing_messaging_youtube.blank?
    l
  end
end
