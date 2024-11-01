class LegacyListingComment < LegacyBase
  set_table_name "listing_comment"
  set_primary_key "comment_id"
  belongs_to :listing, :class_name => 'LegacyListing', :foreign_key => 'comment_listing'

  def best_guess_user( default_user )
    u = User.find_by_email comment_email
    u ? u : default_user
  end
end


#comment_id
#comment_listing
#comment_person
#comment_email
#comment_rating
#comment_title
#comment_detail
#comment_status
#comment_add