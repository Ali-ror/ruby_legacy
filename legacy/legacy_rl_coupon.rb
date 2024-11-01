class LegacyRlCoupon < LegacyBase
  set_table_name "coupons"
  belongs_to :listing, :class_name => 'LegacyListing', :foreign_key => 'listing_id'
end
