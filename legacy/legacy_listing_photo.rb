class LegacyListingPhoto < LegacyBase
  set_table_name "listing_photo"
  set_primary_key "photo_id"
  belongs_to :listing, :class_name => 'LegacyListing', :foreign_key => 'photo_listing'
end
