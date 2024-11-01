class LegacyListingFile < LegacyBase
  set_table_name "listing_files"
  belongs_to :listing, :class_name => 'LegacyListing'
end
